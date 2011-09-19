safari.self.addEventListener("message", function (msgEvent){
  if (msgEvent.name === "tip_this_page"){    
    if (window.top === window) {
      var s = document.createElement('script');
      s.src = 'http://dirtywhitecouch.com/tips/embed_iframe.js';
      document.body.appendChild(s);
    }
  }
}, false);
