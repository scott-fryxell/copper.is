//= require jquery
//= require jquery.cookie
//= require jquery.timeago
//= require jquery.tmpl
//= require shared/Item
//= require shared/copper
$(document).ready(function() {
  jQuery('time').timeago();
  $(document).trigger("copper:" + $('body').attr('id'))

  jQuery.ajax({url:'/users/me',
    dataType:'json',
    success:function(data) {
      copper.me = data;
      $('img.identity').attr('src', copper.get_identity_image())
      $("#signed_in").addClass('show')
      $(document).trigger("copper:" + $('body').attr('id')+ ":me");
    },
    error:function (){
      $("#sign_in").addClass('show')
      $("#sign_in > nav > a > img").click(function(event){
        $(this).addClass("working");
      });
    },

    statusCode: {
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

