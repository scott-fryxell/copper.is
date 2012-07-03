$(document).on("copper:home_index", function (){

  var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
  if(is_chrome){
    $("a.install").click(function(){
      $(this).attr("href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.crx")
    });
  }else if($.browser.safari){
    $("a.install").click(function(){
      $(this).attr("href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.safariextz")
    });
  }else if($.browser.mozilla){
    $("a.install").click(function(){
      var params = {
        "Foo": { URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi?",
                 IconURL: "assets/icons/logo.svg",
                 Hash: "sha1:5f1bd48be013e968d7744d2d44300ea6246dafbb",
                 toString: function () { return "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"; }
        }
      };
      InstallTrigger.install(params);
      return false;
    });
  }else{
    $("a.install").hide();
  }
});

$(document).on("copper:home_index", function (){

  $("a.install").click(function (){
    // this is temporariy until we can get the extensions to trigger the event.
    $(document).trigger("copper:button_installed")
  })

  $(document).on("copper:button_installed",  function(event){
    // hide the welcome screen and show congrats
    $('#welcome').delay(800).slideUp(800);
    $('#congrats').delay(1600).slideDown(800);
    $('#facebook').delay(2400).slideDown(800);
    $('.settings').css("display",'inline-block');
  });
});

$(document).on("copper:home_index:me", function (){
  $('#signin_with_fb').hide();
  $('#welcome').show();

  if('facebook' == copper.me.identities[0].provider){
    var likes_url = 'https://graph.facebook.com/' + copper.me.identities[0].uid + '/likes?limit=8&access_token=' + copper.me.identities[0].token;
    $.getJSON(likes_url).success(function(facebook) {

      $.each(facebook.data,function(i, a_like){
        $.getJSON("http://graph.facebook.com/" + a_like.id).success(function(like){
          console.debug(like.picture)
          like.picture
        })
      })
    })
  }
});



// $.each(data, function(key, val) {
//   items.push('<li id="' + key + '">' + val + '</li>');
// });
//
// $('<ul/>', {
//   'class': 'my-new-list',
//   html: items.join('')
// }).appendTo('body');
