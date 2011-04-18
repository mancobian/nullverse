/** ===========================================================================
  @class Planet
  @brief A planet in an orbital system comprised of stellar bodies.
============================================================================ */

class Planet
{
  static int PLANET_ID = 0;
  String id = null;
  int mRadius = 32;
  bool mEnableShadow = true;
  Orbit mOrbit = null;
  App app = null;

  Planet(
    App app,
    Universe universe,
    PVector barycenter, 
    float planetaryRadius, 
    float orbitalRadius, 
    float orbitalPeriod,
    bool hasShadow)  
  {  
    // Set properties
    this.app = app;
    this.id = "" + (++Planet.PLANET_ID);
    this.mRadius = planetaryRadius;
    this.mEnableShadow = hasShadow;

    // Create orbit
    this.mOrbit = new Orbit(this.app, this);
    this.mOrbit.mRadius = orbitalRadius;
    this.mOrbit.mPeriod = orbitalPeriod;
  }  

  void onKeyboardEvent(event)
  {
    this.mOrbit.onKeyboardEvent(event);
  }

  void onMouseEvent(event)
  {
    this.mOrbit.onMouseEvent(event);
  }

  void resize()
  {
    // this.mOrbit.mBarycenter = this.mBarycenter;
  }

  void update()
  {
  }

  void draw()
  {
    float diameter = this.mRadius * 2.0;
    float shadowOffset = (this.mRadius * 0.1);

    pushMatrix();
    {
      resetMatrix();

      ellipseMode(CENTER);

      translate(
        this.mOrbit.mBodyPosition.x,
        this.mOrbit.mBodyPosition.y,
        this.mOrbit.mBodyPosition.z - this.app.camera.mEye.z);
      
      if (this.mEnableShadow)
      {
        fill (0, 255);
        ellipse(shadowOffset, shadowOffset, diameter, diameter);
      }

      fill (255, 255);
      ellipse(0, 0, diameter, diameter);
    }
    popMatrix();
  }
} // class Planet

