/** ==========================================================================
  @class Orbit
  @brief The orbital path of a stellar body, e.g. planet.
============================================================================ */

class Orbit
{
  int mRadius = 128; // in pixels 
  float mPeriod = 25000.0; // in ms
  PVector mBodyPosition = null;
  App app = null;

  Orbit(App app, Planet planet)  
  {  
    this.app = app;
    this.mBodyPosition = new PVector(0,0,0);

    this.update(0.0);
  }  

  Orbit(App app, Planet planet, int radius, int period)  
  {  
    this.app = app;
    this.mRadius = radius;
    this.mPeriod = period;
    this.mBodyPosition = new PVector(0,0,0);

    this.update(0.0);
  }  

  void onKeyboardEvent(event)
  {
  }

  void onMouseEvent(event)
  {
  }

  void update()
  {
    pushMatrix();
    {
      // Calculate current orbital "angle" from elapsed time (ms)
      float periodElapsed = millis() % this.mPeriod;
      float angle = (periodElapsed / this.mPeriod) * TWO_PI;

      // Update the body's current orbital position
      this.mBodyPosition.x = sin(angle) * this.mRadius; 
      this.mBodyPosition.y = cos(angle) * this.mRadius;
      this.mBodyPosition.z = 0; 

      float x = modelX(this.mBodyPosition.x, this.mBodyPosition.y, this.mBodyPosition.z);
      float y = modelY(this.mBodyPosition.x, this.mBodyPosition.y, this.mBodyPosition.z);
      float z = modelZ(this.mBodyPosition.x, this.mBodyPosition.y, this.mBodyPosition.z);

      this.mBodyPosition.set(x, y, z);
      // println(this.mBodyPosition);
    }
    popMatrix();
  }

  void draw()
  {
    float diameter = this.mRadius * 2.0; 
    // println("Orbital diameter: " + diameter);

    pushMatrix();
    {
      fill (0,0);

      stroke(0, 0, 0, 255);
      strokeWeight(1.0);

      ellipseMode(CENTER);
      ellipse(0, 0, diameter, diameter);
    }
    popMatrix();
  }
} // class Planet

