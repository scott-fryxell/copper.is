chrome.extension.onRequest.addListener( function(request, sender, sendResponse) {
  var s = document.createElement('script');
  s.src = 'http://dirtywhitecouch.com/bookmarklet/embed_iframe.js';
  document.body.appendChild(s);

  if (request.greeting == "hello")
    sendResponse({farewell: "goodbye"});
  else
    sendResponse({}); // snub them.
});

