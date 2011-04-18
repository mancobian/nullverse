/** ===========================================================================
  @class App
  @brief Manages all Processing(.js)-related functionality.
============================================================================ */

class App
{
  Processing processing = null;
  Javascript javascript = null;
  Canvas canvas = null;
  Camera camera = null;
  UI ui = null;
  Universe universe = null;

  App()
  {
  }

  void setup(Processing instance)
  {
    // Init layout
    size(window.innerWidth, window.innerHeight, OPENGL);
    background(0,0);  
    smooth(); /// @note Render anti-aliased.

    // Set target frame rate
    frameRate(24);

    // Optimiziation(s)
    hint(DISABLE_OPENGL_ERROR_REPORT);

    /// Create data members
    this.processing = instance;
    this.processing.setJavascript(window);
    this.camera = new Camera(this);
    this.ui = new UI(this);
    this.universe = new Universe(this);
    this.images = new HashMap(256);

    /// @note This must be called AFTER setting up Processing environment
    this.canvas = new Canvas(this.processing.externals.context); 
    this.canvas.bindExtraMouseEvents(this); 

    // Register event handlers
    this.registerEventHandlers();

    // Create universe
    this.universe.setPopulationSize(0);

    // Setup UI
    this.ui.setup();

    // Raise event signal
    onSetup();
  }

  void registerEventHandlers()
  {
    // Re-assign draw, mouseClicked and possibly other events to the App instance. 
    this.processing.draw = this.draw.bind(this); 
    this.processing.update = this.update.bind(this); 
    this.processing.mouseClicked = this.mouseClicked.bind(this); 
    this.processing.mouseDragged = this.mouseDragged.bind(this); 

    /// Setup app event dispatch
    Input.mouseEventListeners.add(this, this.onMouseEvent);
  }

  void onMouseEvent(event)
  {
    /// Propagate mouse event
    this.camera.onMouseEvent(event);
    this.universe.onMouseEvent(event);
  }

  void mouseDragged()
  {
    MouseEvent event = new MouseEvent(MouseEvent.Types.DRAG);
    this.onMouseEvent(event);
  }

  void mouseClicked()
  {
    MouseEvent event = new MouseEvent(MouseEvent.Types.CLICK);
    this.onMouseEvent(event);
  }
  
  void mouseOver()
  {
    MouseEvent event = new MouseEvent(MouseEvent.Types.OVER);
    this.onMouseEvent(event);
  }

  void mouseLeave()
  {
    MouseEvent event = new MouseEvent(MouseEvent.Types.OUT);
    this.onMouseEvent(event);
  }

  void resize()
  {
    // Resize the canvas
    // size(window.innerWidth, window.innerHeight);

    // Resize the universe
    // this.universe.resize();
  }

  void update()
  {
    // Update top-level objects
    this.universe.update();
    // this.ui.update();
  }

  void draw()
  {
    // Clear canvas
    colorMode(RGB, 255);
    background(0, 0);

    // Initialize per-frame settings
    lights();

    // Resize the canvas
    this.resize();

    // Perform per-frame updates
    this.update();

    // Draw top-level objects
    this.universe.draw();
    // this.ui.draw();
  }
}

