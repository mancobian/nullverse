/** ===========================================================================
  @class Universe
  @brief A universe comprised of stellar bodies, e.g. planets.
============================================================================ */

class Universe
{
  int mNumPlanets = 0;
  int mLastPlanetId = 0;
  PVector mPosition = null;
  PVector mOrientation = null;
  PVector mScale = null;
  PVector tilt = null;
  App app = null;
  HashMap planets = null;
  Array sortedPlanets = null;

  Universe(App app)
  {
    // Create data members
    this.app = app;
    this.mPosition = new PVector(0.0, 0.0, 0.0);
    this.mOrientation = new PVector(0.0, 0.0, 0.0);
    this.mScale = new PVector(1.0, 1.0, 1.0);
    this.tilt = new PVector(0, 0, 0);
    this.planets = new HashMap();
    this.sortedPlanets = null;
  }

  void setPopulationSize(int numPlanets)
  {
    println("Current population size: " + this.mNumPlanets);
    println("Setting population size to: " + numPlanets);

    Planet planet = null;

    if (numPlanets > this.mNumPlanets)
    {
      for (int i = this.mNumPlanets; i < numPlanets; ++i)
      {
        planet = this.pushPlanet();
      }
    }
    else if (numPlanets < this.mNumPlanets)
    {
      for (int i = this.mNumPlanets; i > numPlanets; --i)
      {
        planet = this.popPlanet();
        planet = null;
        // println("Popped a planet.");
      }
      // println("New population size: " + this.mNumPlanets);
    }
    else { return; }
  }

  Planet getLastPlanet()
  {
    // println("Getting the last planet...");
    // println("Starting search with planet ID: " + this.mLastPlanetId);

    Planet planet = null;
    Iterator iterator = this.planets.entrySet().iterator();
    while (iterator.hasNext())
    {
      Map.Entry entry = (Map.Entry)iterator.next();
      int id = (int)entry.getKey();

      if (!planet || (id > planet.id))
      {
        println ("Largest key: " + (int)entry.getKey());
        planet = (Planet)entry.getValue();
      }
    }

    if (planet == null) { println("Failed to find a last planet :("); }
    println ("Found planet with ID: " + planet.id);
    return planet;
  }

  Planet pushPlanet()
  {
    int i = (++this.mNumPlanets);

    PVector barycenter = this.mPosition;
    float planetaryRadius = (i+1);
    float orbitalRadius = planetaryRadius * ((i+1)); // *2);
    float orbitalPeriod = orbitalRadius * ((i * 10.0) + 1000);
    bool hasShadow = true;

    println("Planet " + i + ": barycenter=" + barycenter + ", planetary radius=" + planetaryRadius + ", orbital radius=" + orbitalRadius + ", orbital period=" + orbitalPeriod + " ms");

    // Create and add new planet
    Planet planet = new Planet(
      this.app,
      this,
      barycenter, 
      planetaryRadius, 
      orbitalRadius, 
      orbitalPeriod,
      hasShadow);
    this.planets.put(planet.id, planet);
    this.mLastPlanetId = planet.id;
    return planet;
  }

  Planet popPlanet()
  {
    Planet planet = this.getLastPlanet(); 
    if (planet != null) 
    {
      this.planets.remove(planet.id);
      --this.mNumPlanets;
    }
    return planet;
  }

  void onKeyboardEvent(event)
  {
    // Resize each planet
    Planet planet = null;
    Iterator iterator = this.planets.entrySet().iterator();
    while (iterator.hasNext())
    {
      Map.Entry entry = (Map.Entry)iterator.next();
      planet = (Planet)entry.getValue();
      planet.onKeyboardEvent(event);
    }
  }

  void onMouseEvent(event)
  {
    if (event.type == MouseEvent.Types.DRAG)
    {
      PVector delta = new PVector(
        event.delta.x,
        event.delta.y,
        event.delta.z);
      delta.x /= screen.width;
      delta.y /= screen.height;
          
      switch (this.app.camera.manipulationMode)
      {
        case Camera.ManipulationModes.ROTATE:
        {
          /// Determine the global tilt angle for x, y and z-axis (in radians)
          delta.mult(5.0);
          delta.y *= -1.0;
          this.tilt.add(delta);

          this.tilt.set(
            (this.tilt.x % TWO_PI),
            (this.tilt.y % TWO_PI),
            (this.tilt.z % TWO_PI));
          break;
        }
        case Camera.ManipulationModes.TRANSLATE:
        {
          delta.mult(100.0);
          this.mPosition.x += delta.x;
          this.mPosition.y += delta.y;
          break;
        }
        case Camera.ManipulationModes.ZOOM:
        {
          float scaleFactor = 1000.0;
          this.mScale.x -= (delta.y * scaleFactor);
          this.mScale.y -= (delta.y * scaleFactor);
          this.mScale.z -= (delta.y * scaleFactor);
          break;
        }
      }
    }

    // Propagate event
    Planet planet = null;
    Iterator iterator = this.planets.entrySet().iterator();
    while (iterator.hasNext())
    {
      Map.Entry entry = (Map.Entry)iterator.next();
      planet = (Planet)entry.getValue();
      planet.onMouseEvent(event);
    }
  }

  void resize()
  {
    // Resize each planet
    Planet planet = null;
    Iterator iterator = this.planets.entrySet().iterator();
    while (iterator.hasNext())
    {
      Map.Entry entry = (Map.Entry)iterator.next();
      planet = (Planet)entry.getValue();
      planet.resize();
    }
  }

  void applyTransforms()
  {
    /*
    scale(
      this.mScale.x,
      this.mScale.y,
      this.mScale.z);
    */

    translate(
      this.mPosition.x,
      this.mPosition.y,
      this.mPosition.z + (this.mScale.x));

    rotateY(this.tilt.x);
    rotateX(this.tilt.y);
    rotateZ(this.tilt.z);

    // println("UNIVERSE");
    // println(this.mPosition);
    // printMatrix();
  }

  void updateCamera()
  {
    String data = javascript.getCameraSettings();

    var settings = JSON.parse(data);
    float fovY = settings.fovY;
    float nearClip = settings.nearClip;
    float farClip = settings.farClip;

    this.app.camera.setFovY(fovY);
    this.app.camera.setNearClip(nearClip);
    this.app.camera.setFarClip(farClip);

    this.app.camera.update();
  }

  void update()
  {
    this.updateCamera();

    pushMatrix();
    {
      this.applyTransforms();

      // Update each orbit
      Planet planet = null;
      Iterator iterator = this.planets.entrySet().iterator();
      while (iterator.hasNext())
      {
        Map.Entry entry = (Map.Entry)iterator.next();
        planet = (Planet)entry.getValue();
        planet.mOrbit.update();
      }

      // Update each planet
      iterator = this.planets.entrySet().iterator();
      while (iterator.hasNext())
      {
        Map.Entry entry = (Map.Entry)iterator.next();
        planet = (Planet)entry.getValue();
        planet.update();
      }

      // Sort the planets by depth
      if (javascript != null)
      {
        Planet[] localPlanets = new Array();
        iterator = this.planets.entrySet().iterator();
        while (iterator.hasNext())
        {
          Map.Entry entry = (Map.Entry)iterator.next();
          append(localPlanets, (Planet)entry.getValue());
        }
        this.sortedPlanets = javascript.sortAllPlanets(localPlanets);
        // println(this.sortedPlanets);
      }
    }
    popMatrix();
  }

  void draw()
  {
    /*
    println("UNIVERSE");
    printMatrix();
    */

    pushMatrix();
    {
      this.applyTransforms();

      // Draw planets' orbits
      Iterator iterator = this.planets.entrySet().iterator();
      while (iterator.hasNext())
      {
        Map.Entry entry = (Map.Entry)iterator.next();
        planet = (Planet)entry.getValue();
        planet.mOrbit.draw();
      }
        
      // Draw planets
      hint (DISABLE_DEPTH_TEST);
      noLights();
      {
        Planet planet = null;
        for (int i = 0; i < this.sortedPlanets.length; ++i)
        {
          planet = (Planet)this.planets.get(this.sortedPlanets[i]);        
          planet.draw();
        }
      }
      lights();
      hint (ENABLE_DEPTH_TEST);
    }
    popMatrix();
  }
}; /// class Universe

