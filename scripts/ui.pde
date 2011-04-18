/** ===========================================================================
  @class UI
  @brief A wrapper class for user-interface related functions.
============================================================================ */

class UI
{
  App app;

  UI(App app)
  {
    this.app = app;
  }

  void setup()
  {
    PFont fontA = loadFont("courier");  
    textFont(fontA, 14);
  }

  void updateCamera()
  {
    float fovY = 600;
    float nearClip = 100;
    float farClip = 1000;

    this.app.camera.mFrustum.fovY = fovY;
    this.app.camera.mFrustum.nearClip = nearClip;
    this.app.camera.mFrustum.farClip = farClip;

    this.app.camera.update();
  }

  void update()
  {
    // this.updateCamera();
  }

  void drawStats()
  {
    textMode(MODEL);
    fill(color(0,0,0));
    text("Average Frame Rate: " + (int)frameRate, 10, 10);
    text("Mouse Position: " + mouseX + ", " + mouseY, 10, 30);
  }

  void draw()
  {
    this.updateCamera();
    this.drawStats();
  }
}

