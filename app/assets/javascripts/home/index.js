$(document).on("copper:home_index", function (){
  console.debug("home_index");

  //what's the browser
  var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
  console.debug($.browser)

  if(is_chrome){
    $("a.button").click(function(){
      $(this).attr("href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/chrome.crx")
    });
  }else if($.browser.safari){
    $("a.button").click(function(){
      $(this).attr("href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/safari.safariextz")
    });
  }else if($.browser.mozilla){
    $("a.button").click(function(){
      var params = {
        "Foo": { URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/firefox.xpi?",
                 IconURL: "assets/icons/logo.svg",
                 Hash: "sha1:5f1bd48be013e968d7744d2d44300ea6246dafbb",
                 toString: function () { return "https://github.com/scott-fryxell/copper_extension/blob/master/compiled/firefox.xpi?raw=true"; }
        }
      };
      InstallTrigger.install(params);
      return false;
    });

  }

});
