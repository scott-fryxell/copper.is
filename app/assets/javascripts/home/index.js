$(document).on("load.home_index", function (){
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
                 IconURL: "/assets/icons/logo.svg",
                 Hash: "sha1:52655c2f918f98f9df29ca082e65ead87d9c24cb",
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
$(document).on("load.home_index", function (){
  $("a.install").click(function (event){
    $(document).trigger('copper.button_installed')
  })
  $(document).on('copper.button_installed', function (){
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
$(document).on("me.home_index", function (){
  $('#join figure.step_one').hide();
  $('#join figure.step_two').show();

  var facebook = -1
  for (i in copper.me.identities){
    if(copper.me.identities[i].provider == 'facebook'){
      facebook = copper.me.identities[i]
    }
  }

  if(facebook){
    var likes_url = 'https://graph.facebook.com/' + facebook.username + '/likes?limit=7&access_token=' + copper.me.identities[0].token;
    $.getJSON(likes_url).success(function(facebook) {
      $.each(facebook.data,function(i, a_like){
        $.getJSON("http://graph.facebook.com/" + a_like.id).success(function(like){
          var image = $('<img/>', {src:like.picture})
          $('<a/>', {href:like.link, html:image}).appendTo('#facebook > nav')
        })
      })
    });

    var me_url = 'https://graph.facebook.com/me?&access_token=' + facebook.token;
    $.getJSON(me_url).success(function(me) {
      $('figure.step_two > h5 > p').append('Welcome, ' + me.first_name + '!')
    });
  }
});