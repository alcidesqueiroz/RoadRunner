;(function(global){
  
  /**
   * @class RoadRunner
   * @static
   */
  var RoadRunner = {};

  var host = location.hostname || "localhost";
  var port = 9876;
  
  /**
   * Creates a WebSocket client and listen to the RoadRunner server
   * @method listen
   * @static
   */
  RoadRunner.listen = function(){
    var socket = new WebSocket("ws://" + host + ":" + port);
    var rr = this;
    socket.onmessage = function(msg){  
      var msgJSON = JSON.parse(msg["data"]);
      rr.resolveChange(msgJSON)
    } 
  }

  /**
   * Split a file path in path, file and extension 
   * @method _getPathParts
   * @param url {String} URL to split
   * @return {Object} the Hash containing the URL parts
   * @private
   */
  var _getPathParts = function(url) {
    if(!url.match(/[\/\\]/)) url = "/" + url;

    var m = url.match(/(.*)[\/\\]([^\/\\]+)\.(\w+)$/);
    
    return {
        fullPath: url,
        path: m[1],
        file: m[2],
        ext: m[3]
    };
  };

  /**
   * Shows a warning in console
   * @method _warn
   * @param url {String} Message to be shown
   * @private
   */
  var _warn = function(msg){
    console.warn("RoadRunner:", msg);
  }

  /**
   * Resolve changes depending on file type
   * @method resolveChange
   * @param msg {Object} The JSON message with info about the change
   * @static
   */
  RoadRunner.resolveChange = function(msg){
    var URLparts = _getPathParts(msg.filepath);
    var resolver;
    switch(URLparts.ext.toLowerCase()){
      case "css":
        resolver = CSSResolver;
        break;

      case "js":
        resolver = GenericResolver;
        break;

      case "png":
      case "gif":
      case "svg":
      case "jpg":
      case "jpeg":
        //ToDo: Create a resolver for images to update img tags and backgrounds without reloading the page
        resolver = GenericResolver;
        break;

      case "html":
      case "htm":
        resolver = GenericResolver;

      default:
        resolver = GenericResolver;
    }
    resolver.resolve(URLparts);
    _warn("The file \"" + URLparts.fullPath + "\" has changed at " + msg.modified_at + ".");
  }

  /**
   * Generic strategy to resolve static files changes, 
   * its behaviour is to refresh the page forcing to not use the local cache
   * @class GenericResolver
   * @static
   */
  var GenericResolver = {};
  GenericResolver.resolve = function(URLparts){
    location.reload(true);
  }

  /**
   * Strategy to resolve CSS files changes, 
   * its behaviour is update link tags' href references and force the browser to not using the cache
   * @class CSSResolver
   * @static
   */
  var CSSResolver = {};
  CSSResolver.resolve = function(URLparts){
    var path = URLparts.fullPath;
    var stylesheets = global.document.querySelectorAll("link[href*=\"" + path + "\"]");

    if(stylesheets.length > 0){
      for(var i = 0; i < stylesheets.length; i++){
        var stylesheet = stylesheets[i];
        stylesheet.setAttribute("href", path + "?rand=" + Math.floor(Math.random() * 9999));

      }
    }
  }
      
  RoadRunner.listen();
})(window);