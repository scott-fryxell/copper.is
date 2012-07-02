$(document).on("copper:home_index", function (){
  var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
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
  }else{
    $("a.button").hide();
  }

});

$(document).on("copper:home_index:me", function (){
  if('facebook' == copper.me.identities[0].provider){

    //get the users recent likes
    var likes_url = 'https://graph.facebook.com/' + copper.me.identities[0].uid + '/likes?limit=8&access_token=' + copper.me.identities[0].token;
    $.getJSON(likes_url).success(function(facebook) {

      $.each(facebook.data,function(i, a_like){
        $.getJSON("http://graph.facebook.com/" + a_like.id).success(function(like){
          console.debug(like)
          like.picture
        })
      })
    })

  }
});



$.each(data, function(key, val) {
  items.push('<li id="' + key + '">' + val + '</li>');
});

$('<ul/>', {
  'class': 'my-new-list',
  html: items.join('')
}).appendTo('body');
