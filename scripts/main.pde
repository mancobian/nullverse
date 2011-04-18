/* ============================================================================
  Notes
============================================================================ */

/* ==
= Enums in Javascript
-----
=   http://stackoverflow.com/questions/1314187/creating-an-enum-in-javascript
=   https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/freeze
=====
= Exploiting Processing.js by mixing Processing and javascript legally
-----
=   http://processingjs.nihongoresources.com/interfacing/
== */

/* ============================================================================
  Directives
============================================================================ */

/* 
@pjs pauseOnBlur="true";
  transparent="true";
  preload="images/logo.png";
*/

/* ============================================================================
  Javascript Interface
============================================================================ */

interface Javascript
{
  String[] sortAllPlanets(Planet[] planets);
  int sortPlanets(Planet a, Planet b);
  void onSetup();
  String getCameraSettings();
}

/* ============================================================================
  Globals
============================================================================ */

App app = new App(); 
Javascript javascript = null;
window.Processing.data.app = app;

void setJavascript(instance)
{
  javascript = instance;
}

void setup()
{ 
  app.setup(this);
} 

