$(document).on("load.home_index", function (){
  var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
  if(is_chrome){
    $("a.install").click(function(){
      var url = "https://chrome.google.com/webstore/detail/aoioappfaobhjafcnnajbndogjhaodpb"
      chrome.webstore.install(url, function(){
       $(document).trigger('copper.button_installed')
      }, function (event){
        console.debug('not working', event)
        alert(event)
      })
    });
  }else if($.browser.safari){
    $("a.install").click(function(){
      $(this).attr("href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.safariextz")
      $(document).trigger('copper.button_installed')
    });
  }else if($.browser.mozilla){
    $("a.install").click(function(){
      var params = {
        "Foo": { URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi?",
                 IconURL: "/assets/icons/logo.svg",
                 Hash: "sha1:8e169c7ec8d5c2f21e5c6e2d1d173bedc001fe35",
                 toString: function () { return "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"; }
        }
      };
      InstallTrigger.install(params);
      $(document).trigger('copper.button_installed')
      return false;
    });
  }else{
    $("a.install").hide();
  }
});
$(document).on("load.home_index", function (){
  function show_sample(element){
    if('nope' != $(element).attr('data-distance')){
      $("#samples > nav > a").removeClass("selected")
      $(element).addClass("selected")
      $('#samples > figure').animate({marginLeft: $(element).attr('data-distance')})
    }      
  }

  $(document).on('copper.button_installed', function (){
    $('#join').delay(0).fadeOut(800);
    $('#congrats').delay(800).fadeIn(800);
    $('#facebook').delay(800).fadeIn(800);
    $('#settings').delay(800).fadeIn(800, function (){
      $('#settings').delay(800).css("display",'block');
    });
  })
  $("#samples > nav > a").click(function (event){
    event.preventDefault();
    clearInterval(carousel);
    show_sample(this);
  });

  var carousel = setInterval(function(){
    if("more" ==$("#samples > nav > a.selected").next().attr('id')){
      show_sample($("#samples > nav > a:first-child"))
    }else {
      show_sample($("#samples > nav > a.selected").next())
    }
  },5000);

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
    var likes_url = 'https://graph.facebook.com/' + facebook.username + '/likes?limit=10&access_token=' + facebook.token;
        $.getJSON(likes_url).success(function(facebook) {
      $.each(facebook.data,function(i, a_like){
        $.getJSON("https://graph.facebook.com/" + a_like.id).success(function(like){
          var image = $('<img/>', {src:"https://graph.facebook.com/" + like.id + "/picture"})
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
