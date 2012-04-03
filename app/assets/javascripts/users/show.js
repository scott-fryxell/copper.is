//= require shared/current_user
//= require shared/tip_rate


$(document).on("get:current_user", function () {
  $('form#fan_email > button').click(function (event) {
    var email = $('#user_email').val();
    var at_pos=email.indexOf("@");
    var dot_pos=email.lastIndexOf(".");


    if (at_pos < 1 || dot_pos < at_pos+2 || dot_pos+2>=email.length) {
      console.error("invalid email");
      $('form#fan_email p').append("invalid email");
      $('#user_email').addClass("invalid");
    }else {
      $('form#fan_email p').empty();
      $('#user_email').removeClass("invalid");
    }

    $.ajax({
      type: $('form#fan_email').attr("method"),
      url: $('form#fan_email').attr('action'),
      data: $('form#fan_email').serialize(),
    });
  });
});


$(document).on("get:current_user", function () {
  $('form#fan_name > button').click(function (event) {
    $.ajax({
      type: $('form#fan_name').attr("method"),
      url: $('form#fan_name').attr('action'),
      data: $('form#fan_name').serialize(),
    });
  });
});
