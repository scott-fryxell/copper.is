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

  $("a.install").click(function (event){

    $('#join').delay(0).fadeOut(800);
    $('#congrats').delay(800).fadeIn(800);
    $('#facebook').delay(800).fadeIn(800);
    $('#settings').delay(800).fadeIn(800, function (){
      $('#settings').delay(800).css("display",'block');
    });
  })

  $("#samples > nav > a").click(function (event){
    if('nope' != $(this).attr('data-distance')){
      $("#samples > nav > a").removeClass("selected")
      $(this).addClass("selected")
      $('#samples > figure').animate({marginLeft: $(this).attr('data-distance')})
    }
  });

});
$(document).on("copper:home_index:me", function (){
  $('#join figure.step_one').hide();
  $('#join figure.step_two').show();

  if('facebook' == copper.me.identities[0].provider){
    var likes_url = 'https://graph.facebook.com/' + copper.me.identities[0].uid + '/likes?limit=7&access_token=' + copper.me.identities[0].token;
    $.getJSON(likes_url).success(function(facebook) {
      $.each(facebook.data,function(i, a_like){
        $.getJSON("http://graph.facebook.com/" + a_like.id).success(function(like){
          var image = $('<img/>', {src:like.picture})
          $('<a/>', {href:like.link, html:image}).appendTo('#facebook > nav')
        })
      })
    });

    var me_url = 'https://graph.facebook.com/me?&access_token=' + copper.me.identities[0].token;
    $.getJSON(me_url).success(function(me) {
      $('figure.step_two > h5 > p').append('Welcome, ' + me.first_name + '!')
    });
  }
});
