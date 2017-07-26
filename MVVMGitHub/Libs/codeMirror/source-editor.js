function getExtension(name) {
  if (!name)
    return null;

  var lastDot = name.lastIndexOf(".");
  if (lastDot == -1 || lastDot + 1 == name.length)
    return null;
  else
    return name.substring(lastDot + 1).toLowerCase();
}

function updateWidth() {
  var lines = document.getElementsByClassName("CodeMirror-lines")[0];
  if (lines) {
    var root = document.getElementsByClassName("CodeMirror")[0];
    if (root && lines.scrollWidth > lines.clientWidth)
      root.style.width = lines.scrollWidth + "px";
  }
}

function loadImage(type, content) {
  var img = document.createElement("img");
  img.setAttribute("src", "data:image/" + type + ";base64," + content);
  document.body.appendChild(img);
}

 
function loadContent(data){
   var title = data.title;
   var extension = getExtension(title);
   if ("png" == extension || "gif" == extension) {
     loadImage(extension, data["Base64String"]);
     return;
   } else if ("jpg" == extension || "jpeg" == extension) {
     loadImage("jpeg", data["Base64String"]);
     return;
   }
   CodeMirror.modeURL = "mode/%N/%N.js";
   var config = {};
   config.value = data.UTF8String;
   config.readOnly = "nocursor";
   config.lineNumbers = true;
   config.autofocus = false;
   config.lineWrapping = true;
   config.dragDrop = false;
   config.fixedGutter = false;

   var editor = CodeMirror(document.body, config);
   var mode, spec;
   var info = CodeMirror.findModeByExtension(extension);
   if (info) {
     mode = info.mode;
     spec = info.mime;
   }

   if (mode) {
     editor.setOption("mode", spec);
     CodeMirror.autoLoadMode(editor, mode);
   }
   if (!config.lineWrapping) updateWidth();
}

function setupWebViewJavascriptBridge(callback) {
            if (window.WebViewJavascriptBridge) { return callback(WebViewJavascriptBridge); }
            if (window.WVJBCallbacks) { return window.WVJBCallbacks.push(callback); }
            window.WVJBCallbacks = [callback];
            var WVJBIframe = document.createElement('iframe');
            WVJBIframe.style.display = 'none';
            WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
            document.documentElement.appendChild(WVJBIframe);
            setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
        }

setupWebViewJavascriptBridge(function(bridge) {
  bridge.registerHandler('getInitDataFromObjC', function(data, responseCallback) {
    loadContent(data);
  })
})
