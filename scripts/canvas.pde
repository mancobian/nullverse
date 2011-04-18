/****************************************************************** 
 * Canvas 
 ******************************************************************/ 

class Canvas 
{ 
  CanvasRenderingContext2D context; 
  DOMElement domElement; 
  boolean isMouseOver; 

  Canvas(context) 
  { 
    // console.log(context.canvas); 
    this.context = context; 
    this.domElement = context.canvas; 
  } 

  void bindExtraMouseEvents(listener) 
  { 
    $(this.domElement).mouseover(listener.mouseOver.bind(listener)); 
    $(this.domElement).mouseleave(listener.mouseLeave.bind(listener)); 
  } 
}

