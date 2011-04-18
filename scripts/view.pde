/** ===========================================================================
  @class ViewManager
  @brief A utility for controlling the view.
============================================================================ */

class View
{
  PVector position = null;
  PVector direction = null;
  PVector up = null;
  PVector right = null;

  View()
  {
    this.position = new PVector(0.0, 0.0, 0.0);
    this.direction = new PVector(0.0, 0.0, 0.0);
    this.up = new PVector(0.0, 1.0, 0.0);
    this.right = new PVector(1.0, 0.0, 0.0);
  }
}
