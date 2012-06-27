//= require jquery
//= require jquery.cookie
//= require jquery.timeago
//= require jquery.tmpl
//= require shared/Item
//= require shared/copper
//= require home/index
$(document).ready(function() {
  jQuery('time').timeago();
  $(document).trigger("copper:" + $('body').attr('id'))
  $("#sign_in > nav > a").hover(
    function (){
      $(this).find("img").hide();
      $(this).find("img.hover").show();
    },
    function (){
      $(this).find("img").show();
      $(this).find("img.hover").hide();
    }
  );

  $("img[alt=Gear]").click(function(event){
    $(this).addClass("working");
  });


  jQuery.ajax({url:'/users/me',
    dataType:'json',
    success:function(data) {
      copper.me = data;
      $('img.identity').attr('src', copper.get_identity_image())
      $("#signed_in").addClass('show')
      $(document).trigger("copper:" + $('body').attr('id')+ ":me");
    },
    statusCode: {
      401:function (){
        $("#sign_in").addClass('show')
        $("#sign_in > nav > a > img").click(function(event){
          $(this).addClass("working");
        });
      }
    }
  });
});

$(document).on("copper:me", function (){

  //todo get all of the users social media data

  //TODO if there logged in for the first time show welcome message
  // if(copper.me.logins == 1){
  //   copper.me.name
  // }

  //TODO display any messages for user

});

