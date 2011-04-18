// @note Taken from blog article, "How to copy arrays and objects in Javascript"
// @author Brian Huisman
// @url http://my.opera.com/GreyWyvern/blog/show.dml/1725165

/*
Object.prototype.clone = function() 
{
  var newObj = (this instanceof Array) ? [] : {};
  for (i in this) 
  {
    if (i == 'clone') 
    {
      continue;
    }
    else if (this[i] && typeof this[i] == "object") 
    {
      newObj[i] = this[i].clone();
    } 
    else 
    {
      newObj[i] = this[i]
    }
  } return newObj;
};
*/

// @note Inspired by comments found on http://johankanngard.net
// @author Tom Van Schoor
// @url http://johankanngard.net/2005/11/14/remove-an-element-in-a-javascript-array

Array.prototype.remove = function(item) 
{
  var index = this.indexOf(item);
  if(index != -1) { this.splice(index, 1); } // Removes one (1) element from 'index'
};

Array.prototype.clear = function() 
{
  this = [];
  // this.length = 0;
};
