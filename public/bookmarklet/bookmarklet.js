function load_flb(url){
  var s = document.createElement('script');
  s.type = 'text/javascript';
  s.async = true;
  s.src = url;
  document.body.appendChild(s);
}
load_flb("http://0.0.0.0:3000/behavior/tip_engine.js")

// When the patron is not logged in redirect to the login page.
// Keep the tip in the session until user logs in.

