//= require shared/current_user
$(document).ready(function(){
  $("section > header > a").click(function(event){
    event.preventDefault();
    var div = $(this).parents("section").find("div");
    var form = $(this).parents("section").find("form")
    $(this).animate({opacity:0}, 200);
    div.animate({opacity:0},500, function (){
      div.css("display", "none")
      form.css("display", "inline-block")
      form.animate({opacity:1},500);
    });
  });

  $("section > form").submit(function(event){
    event.preventDefault()
    div = $(this).parents("section").find("div")
    $(this).animate({opacity:0},500,function (){
      $(this).css("display", "none")
      $(this).parents("section").find("header > a").animate({opacity:1}, 200)
      div.css("display","inline-block")
      div.animate({opacity:1}, 500)
    });
  });

});

// $(document).on("get:current_user", function () {
//   $('form#fan_email').submit(function (event) {
//     event.preventDefault()
//     var email = $('#user_email').val();
//     var at_pos=email.indexOf("@");
//     var dot_pos=email.lastIndexOf(".");
//
//     if (at_pos < 1 || dot_pos < at_pos+2 || dot_pos+2>=email.length) {
//       $('form#fan_email p').append("invalid email");
//       $('#user_email').addClass("invalid");
//     }else {
//       $('form#fan_email p').empty();
//       $('#user_email').removeClass("invalid");
//     }
//
//     $.ajax({
//       type: $('form#fan_email').attr("method"),
//       url: $('form#fan_email').attr('action'),
//       data: $('form#fan_email').serialize(),
//     });
//   });
// });
//
// $(document).ready(function() {
//   $('#month > option[value='+ new String(new Date().getMonth() + 1) +']').attr('selected', 'selected')
//   $("#credit_card > form").submit(function(event) {
//     $("#credit_card > h1").text("Processing your order...");
//     event.preventDefault();
//     $('#credit_card > form > input[type=submit]').attr("disabled", "disabled"); // disable the submit button to prevent repeated clicks
//     var email = $('#email').val();
//     var at_pos=email.indexOf("@");
//     var dot_pos=email.lastIndexOf(".");
//
//     if (at_pos < 1 || dot_pos < at_pos+2 || dot_pos+2>=email.length) {
//       console.error("invalid email number");
//       $("#credit_card > h1").text("We wanna email you a reciept");
//       $('#email').addClass("invalid");
//     }else {
//       $('#email').removeClass("invalid");
//     }
//     if( !Stripe.validateCardNumber( $('#number').val() ) ){
//       console.error("invalid credit card number");
//       $("#credit_card > h1").text("credit card number is invalid");
//       $('#number').addClass("invalid");
//     } else {
//       $('#number').removeClass("invalid");
//     }
//     if( !Stripe.validateCVC($('#cvc').val() ) ){
//       $("#credit_card > h1").text("CVC is invalid");
//       console.error("invalid cvc");
//       $('#cvc').addClass("invalid");
//     } else {
//       $('#cvc').removeClass("invalid");
//     }
//     if( !Stripe.validateExpiry($('#month').val(), $('#year').val()) ) {
//       console.error("invalid expiration")
//       $("#credit_card > h1").text("Expiration date is invalid");
//       $('#month').addClass("invalid");
//       $('#year').addClass("invalid");
//     } else {
//       $('#month').removeClass("invalid");
//       $('#year').removeClass("invalid");
//     }
//     if( $("#site_terms:checked").length == 0 ){
//       $("#credit_card > h1 ").text("Do you agree to our terms of service?");
//       console.error("must agree to terms");
//       $('#site_terms').addClass("invalid");
//     }else{
//       $('#site_terms').removeClass("invalid");
//     }
//     if($('#credit_card .invalid').length > 0){
//       console.debug('invalid');
//       $('#credit_card > form > input[type=submit]').removeAttr("disabled");
//       return false;
//     } else {
//       $("#credit_card > h1").text("Processing your order...");
//     }
//     Stripe.createToken(
//       {
//         number: $('#number').val(),
//         cvc: $('#cvc').val(),
//         exp_month: $('#month').val(),
//         exp_year: $('#year').val(),
//         email: $('#email').val()
//       },
//       $('#total_in_cents').val(), function (status, response) {
//         // console.debug(status, response);
//         if (response.error) {
//           //show the errors on the form
//           $("#credit_card > h1 ").text(response.error.message);
//           $('#credit_card > form > input[type=submit]').removeAttr("disabled");
//         } else {
//           var form$ = $("#credit_card > form");
//           // token contains id, last4, and card type
//           var token = response['id'];
//           // insert the token into the form so it gets submitted to the server
//           form$.append("<input type='hidden' name='stripe_token' value='" + token + "'/>");
//           // and submit
//           // form$.get(0).submit();
//           jQuery.ajax({
//              url: $(form$).attr("action"),
//              type: $(form$).attr("method"),
//              data: $(form$).serialize()
//            });
//
//         }
//       }
//     );
//     return false;
//   });
// });
// $(document).on("get:current_user", function () {
//   $('form#tip_rate > select > option[value=' + current_user.tip_preference_in_cents +']').attr('selected', true)
//   $('form#tip_rate > select').change(function (event) {
//     $.ajax({
//       type: $('form#tip_rate').attr("method"),
//       url: $('form#tip_rate').attr('action'),
//       data: $('form#tip_rate').serialize(),
//     });
//   });
// });
