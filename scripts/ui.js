// Global Processing data container
window.Processing.data = {}

function sortAllPlanets(planets)
{
  planets.sort(sortPlanets);

  var sortedIds = [];

  for (var i = 0; i < planets.length; ++i)
  {
    sortedIds[i] = planets[i].id;
  }
  return sortedIds;
}

function sortPlanets(a, b)
{
  if (a.mOrbit.mBodyPosition.z < b.mOrbit.mBodyPosition.z)
    return -1;
  else if (a.mOrbit.mBodyPosition.z > b.mOrbit.mBodyPosition.z)
    return 1;
  else
    return 0;
}

function getCameraSettings()
{
  var settings = 
  {
    fovY: $("#camera-settings-fov-slider").slider("value"),
    nearClip: $("#camera-settings-clip-slider").slider("values", 0),
    farClip: $("#camera-settings-clip-slider").slider("values", 1)
  };
  return JSON.stringify(settings);
}

function onSetup()
{
  var camera = window.Processing.data.app.camera;
  updateCameraFovY(camera.mFrustum.fovY);

  var pos = getCameraPosition();
  updateCameraPosition(pos);

  var universe = window.Processing.data.app.universe;
  updatePopulationSize($("#map-settings-population-slider").slider("value"));
}

function updateCameraFovY(fovY)
{
  // Update camera UI value
  fovY = $("#camera-settings-fov-slider").slider("value");
  $("#camera-settings-fov-value").val(fovY);

  // Update camera actual value
  var camera = window.Processing.data.app.camera;
  camera.mFrustum.setFovY(fovY);
}

function getCameraPosition()
{
  // Get camera position values from UI
  var pos = 
  {
    x: $("#camera-settings-xpos-slider").slider("value"),
    y: $("#camera-settings-ypos-slider").slider("value"),
    z: $("#camera-settings-zpos-slider").slider("value")
  };
  return pos;
}

function updateCameraPosition(pos)
{
  // Update UI value(s)
  $("#camera-settings-xpos-value").val(pos.x);
  $("#camera-settings-ypos-value").val(pos.y);
  $("#camera-settings-zpos-value").val(pos.z);

  // Update Processing value(s)
  var camera = window.Processing.data.app.camera;
  camera.setPosition(pos.x, pos.y, pos.z);
}

function updatePopulationSize(size)
{
  // Update Processing value(s)
  var universe = window.Processing.data.app.universe;
  universe.setPopulationSize(size);
}

// jQuery initialization
$(function() {

/* ============================================================================
 * MAP SETTINGS
 * ==========================================================================*/

$("#map-settings-population-slider").slider({
  min: 1,
  max: 100,
  value: 13,
  step: 1,
  slide: function(event, ui)
  {
    // Update UI value
    $("#map-settings-population-value").val(ui.value);

    // Update Processing value
    updatePopulationSize(ui.value);
  }
});
$("#map-settings-population-value").val($("#map-settings-population-slider").slider("value"));

/*
$("#map-settings-shadow-slider").slider({
  min: 1,
  max: 100,
  value: 65,
  step: 1,
  slide: function(event, ui)
  {
    // Update UI value
    $("#map-settings-shadow-value").val(ui.value);

    // Update Processing value
    updateDropShadowOpacity(ui.value);
  }
});
$("#map-settings-shadow-value").val($("#map-settings-shadow-slider").slider("value"));
*/

/* ============================================================================
 * CAMERA SETTINGS
 * ==========================================================================*/

$("#camera-settings-xpos-slider").slider({
  min: -1000,
  max: 1000,
  value: 0,
  step: 1,
  slide: function(event, ui)
  {
    var pos = getCameraPosition();
    pos.x = ui.value;
    updateCameraPosition(pos);
  }
});
$("#camera-settings-xpos-value").val($("#camera-settings-xpos-slider").slider("value"));

$("#camera-settings-ypos-slider").slider({
  min: -1000,
  max: 1000,
  value: 0,
  step: 1,
  slide: function(event, ui)
  {
    var pos = getCameraPosition();
    pos.y = ui.value;
    updateCameraPosition(pos);
  }
});
$("#camera-settings-ypos-value").val($("#camera-settings-ypos-slider").slider("value"));

$("#camera-settings-zpos-slider").slider({
  min: -10000,
  max: 10000,
  value: 7500,
  step: 1,
  slide: function(event, ui)
  {
    var pos = getCameraPosition();
    pos.z = ui.value;
    updateCameraPosition(pos);
  }
});
$("#camera-settings-zpos-value").val($("#camera-settings-zpos-slider").slider("value"));

$("#camera-settings-fov-slider").slider({
  min: 10,
  max: 1000,
  value: 60,
  step: 10,
  slide: function(event, ui)
  {
    // Update UI value
    $("#camera-settings-fov-value").val(ui.value);

    // Update Processing value
    var camera = window.Processing.data.app.camera;
    camera.setFovY(ui.value);
  }
});
$("#camera-settings-fov-value").val($("#camera-settings-fov-slider").slider("value"));

$("#camera-settings-clip-slider").slider({
  min: 1,
  max: 100000,
  values: [10, 75000],
  step: 10,
  slide: function(event, ui)
  {
    // Update UI value
    $("#camera-settings-clip-value").val("Near: " + ui.values[0] + ", Far: " + ui.values[1]);

    // Update Processing value(s)
    var camera = window.Processing.data.app.camera;
    camera.setNearClip(ui.values[0]);
    camera.setFarClip(ui.values[1]);
  }
});

$("#camera-settings-clip-value").val(
    "Near: " + $("#camera-settings-clip-slider").slider("values", 0) 
    + ", Far: " + $("#camera-settings-clip-slider").slider("values", 1)
);

/* ============================================================================
 * VIEW SETTINGS
 * ==========================================================================*/

$("#settings").accordion
({
  animated: false,
  autoHeight: false,
  header: 'h2',
  collapsible: true
});
$("#view-settings-buttonset-pan").button();
$("#view-settings-buttonset-rotate").button(); 
$("#view-settings-buttonset-zoom").button();
$("#view-settings-buttonset").buttonset();
$("#view-settings-buttonset-pan").button( "option", "icons", { primary: 'ui-icon-arrowthick-2-e-w', secondary: '' } );
$("#view-settings-buttonset-rotate").button( "option", "icons", { primary: 'ui-icon-arrowreturnthick-1-e', secondary: '' } );
$("#view-settings-buttonset-zoom").button( "option", "icons", { primary: 'ui-icon-zoomin', secondary: '' } );
$("#view-settings-buttonset-pan").click(function(){
  window.Processing.data.app.camera.setManipulationMode(1);  
});
$("#view-settings-buttonset-rotate").click(function(){
  window.Processing.data.app.camera.setManipulationMode(2);  
});
$("#view-settings-buttonset-zoom").click(function(){
  window.Processing.data.app.camera.setManipulationMode(3);  
});

});

