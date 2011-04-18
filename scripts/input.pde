/** ===========================================================================
  @class MouseEvent
  @brief 
============================================================================ */

class MouseEvent
{
  static var Types = Object.freeze({
    "CLICK":1, 
    "DRAG":2, 
    "MOVE":3, 
    "OUT":4, 
    "OVER":5, 
    "PRESS":6, 
    "RELEAS":7
  });

  var button;
  PVector current;
  PVector delta;
  PVector ratio;
  Types type;

  MouseEvent(type)
  {
    this.type = type;
    this.button = mouseButton;
    this.current = new PVector(mouseX, mouseY, 0.0);
    this.delta = new PVector(
      (this.current.x - pmouseX), 
      (this.current.y - pmouseY), 
      0.0);
    this.ratio = new PVector(
      (this.current.x / window.innerWidth),
      (this.current.y / window.innerHeight),
      1.0);
  }
}

/** ===========================================================================
  @class KeyboardEvent
  @brief 
============================================================================ */

class KeyboardEvent
{
  static var Types = Object.freeze({
    "PRESSED":1, 
    "RELEASED":2,
    "TYPED":3
  });

  char key;
  Types type;
}

/** ===========================================================================
  @class Input
  @brief 
============================================================================ */

static class Input
{
  static Delegate mouseEventListeners = new Delegate();
  static Delegate keyboardEventListeners = new Delegate();
}

/** ===========================================================================
  Processing.js Events
============================================================================ */

void mouseMoved()
{
  MouseEvent event = new MouseEvent(MouseEvent.Types.MOVE);
  Input.mouseEventListeners.invoke(event);
}

