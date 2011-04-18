function Callback(instance, method)
{
  this.instance = instance;
  this.method = method;
};

function Delegate ()
{
  this.callbacks = [];
};


Delegate.prototype.add = function(instance, method)
{
  // Store callback object
  var callback = new Callback(instance, method);
  this.callbacks.push(callback);
  return callback;
}

Delegate.prototype.remove = function(callback)
{
  this.callbacks.remove(callback);
}

Delegate.prototype.clear = function()
{
  this.callbacks.clear();
}

Delegate.prototype.invoke = function()
{
  /*
  // Create callback object
  // @author Andrew Fedoniouk
  // @url http://www.terrainformatica.com/?p=13
  var callback = null;
  if (arguments.length > 2) /// @note 1 = 'instance', 2 = 'method'
  {
    var params = [];
    for (var n = 2; n < arguments.length; ++n) { params.push(arguments[n]); }
    callback = function() { return method.apply(instance, params); }
  }
  else
  {
    callback = function() { return method.call(instance); }
  }
  */

  var callback = null;
  if (arguments.length > 0)
  { 
    for (var i = 0; i < this.callbacks.length; ++i)
    {
      callback = this.callbacks[i];
      callback.method.apply(callback.instance, arguments);
    }
  }
  else
  {
    for (var i = 0; i < this.callbacks.length; ++i)
    {
      callback = this.callbacks[i];
      callback.method.call(callback.instance);
    }
  }
}

