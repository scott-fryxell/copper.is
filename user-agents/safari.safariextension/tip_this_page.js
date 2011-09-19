safari.self.addEventListener("message", function (msgEvent){
  if (msgEvent.name === "tip_this_page"){    
    if (window.top === window) {
      console.debug("i'm all up in it")
      var s = document.createElement('script');
      s.src = 'http://dirtywhitecouch.com/bookmarklet/embed_iframe.js';
      document.body.appendChild(s);
    }
  }
}, false);
