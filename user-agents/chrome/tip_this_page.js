chrome.extension.onRequest.addListener( function(request, sender, sendResponse) {
  var s = document.createElement('script');
  s.src = 'http://dirtywhitecouch.com/tips/embed_iframe.js';
  document.body.appendChild(s);
});

