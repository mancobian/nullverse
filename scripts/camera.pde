/** ===========================================================================
  @class Frustum
  @brief A utility for representing a camera view frustum.
  @note Perspective frustum calculations referenced from the 
    NeHe article, "Replacment For gluPerspective" by James Heggie.
  @url http://nehe.gamedev.net/data/articles/article.asp?article=11
============================================================================ */

class Frustum
{
  bool dirty;
  float fovY, aspectRatio, nearClip, farClip;

  Frustum()
  {
    this.set(60.0, (float)window.innerWidth/(float)window.innerHeight, 1.0, 5000.0);
  }

  Frustum(
    float fovY, 
    float aspectRatio, 
    float nearClip, 
    float farClip)
  {
    this.set(fovY, aspectRatio, nearClip, farClip);
  }

  void set(float fovY, float aspect, float near, float far)
  {
    this.fovY = fovY; 
    this.aspectRatio = aspect; 
    this.nearClip = near; 
    this.farClip = far;
    this.dirty = true;
  }

  void setNearClip(float nearClip)
  {
    this.nearClip = nearClip;
    this.dirty = true;
  }

  void setFarClip(float farClip)
  {
    this.farClip = farClip;
    this.dirty = true;
  }

  void setFovY(fovY)
  {
    this.fovY = fovY;
    this.dirty = true;
  }

  void update()
  {
    // if (this.dirty)
    {
      // Calculate the half-height of the near clip plane
      // float halfHeight = tan((this.fovY / 2.0) / (180.0 * PI)) * this.nearClip;
      float halfHeight = tan(this.fovY / (360.0 * PI)) * this.nearClip;

      // Calculate the half-width of the near clip plane
      float halfWidth = halfHeight * this.aspectRatio;

      // Update the perspective camera frustum properties
      frustum(
        -halfWidth, halfWidth, 
        -halfHeight, halfHeight, 
        this.nearClip, this.farClip);

      // Unset the dirty flag
      this.dirty = false;

      /*
      println("===== Frustum =====");
      println("=> FOVy: " + this.fovY);
      println("=> Aspect Ratio: " + this.aspectRatio);
      println("=> Near Clip: " + this.nearClip);
      println("=> Far Clip: " + this.farClip);
      println("=> Near Clip Plane Width: " + (halfWidth*2.0));
      println("=> Near Clip Plane Height: " + (halfHeight*2.0));
      */
    }
  }
}

/** ===========================================================================
  @class Camera
  @brief A utility for managing an active camera.
  @note -z points INTO the screen, away from the viewer.
============================================================================ */

class Camera
{
  static var ManipulationModes = Object.freeze
  ({
    "TRANSLATE":1, 
    "ROTATE":2,
    "ZOOM":3
  });

  static var RenderModes = Object.freeze
  ({
    "PERSPECTIVE":1, 
    "ORTHOGRAPHIC":2
  });

  RenderModes renderMode = null; 
  ManipulationModes manipulationMode = null;
  PVector mEye = null; 
  PVector mLookat = null;
  PVector mUp = null;
  Frustum mFrustum = null;
  App app = null;

  Camera(App app)
  {
    this.app = app;
    this.renderMode = Camera.RenderModes.PERSPECTIVE;
    this.manipulationMode = Camera.ManipulationModes.ROTATE;
    this.mFrustum = new Frustum();
    this.mEye = new PVector(0,0,0);
    this.mLookat = new PVector(0,0,0);
    this.mUp = new PVector(0, 1, 0);
  }

  void setManipulationMode(ManipulationModes mode)
  {
    this.manipulationMode = mode;
  }

  void setRenderMode(RenderModes mode)
  {
    this.renderMode = mode;
  }

  void setPosition(PVector position)
  {
    this.mEye.set(position.x, position.y, position.z);
  }
  
  void setPosition(float x, float y, float z)
  {
    this.mEye.set(x, y, z);
  }

  void setDirection(PVector direction)
  {
  }

  void setFrustum(float fovY, float aspect, float near, float far)
  {
    this.mFrustum.fovY = fovY; 
    this.mFrustum.aspectRatio = aspect; 
    this.mFrustum.nearClip = near; 
    this.mFrustum.farClip = far;
    this.mFrustum.dirty = true;
  }

  void setNearClip(float nearClip)
  {
    this.mFrustum.nearClip = nearClip;
    this.mFrustum.dirty = true;
  }

  void setFarClip(float farClip)
  {
    this.mFrustum.farClip = farClip;
    this.mFrustum.dirty = true;
  }

  void setFovY(fovY)
  {
    this.mFrustum.fovY = fovY;
    this.mFrustum.dirty = true;
  }

  void onMouseEvent(event)
  {
  /*
    if ((this.manipulationMode == ManipulationModes.TRANSLATE) && (event.type == MouseEvent.Types.DRAG))
    {
      this.mEye.add(event.delta.x, event.delta.y, 0.0);
      this.setPosition(this.mEye);
    }
    */
  }

  void update()
  {
    /// Set camera mode
    switch (this.renderMode)
    {
      case Camera.RenderModes.ORTHOGRAPHIC: 
      { 
        ortho(); 
        break; 
      }
      case Camera.RenderModes.PERSPECTIVE: 
      default:
      { 
        perspective(); 
        break; 
      }
    }

    /// Update the camera frustum
    this.mFrustum.update();

    /// Update camera
    camera(
      this.mEye.x, this.mEye.y, this.mEye.z,
      this.mLookat.x, this.mLookat.y, this.mLookat.z,
      this.mUp.x, this.mUp.y, this.mUp.z);

    // println(this.mEye);
  }
}

