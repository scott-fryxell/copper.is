// this identifies your website in the createToken call below
$(document).ready(function() {

  $("#credit_card").submit(function(event) {
    $("header > h1").text("working...");
    event.preventDefault();
    $('#credit_card input[type=submit]').attr("disabled", "disabled"); // disable the submit button to prevent repeated clicks


    var email = $('#email').val();
    var at_pos=email.indexOf("@");
    var dot_pos=email.lastIndexOf(".");
    if (at_pos < 1 || dot_pos < at_pos+2 || dot_pos+2>=email.length) {
      console.error("invalid email number");
      $("header > h1").text("We wanna email you a reciept");
      $('#email').addClass("invalid");
    }else {
      $('#email').removeClass("invalid");
    }

    if( !Stripe.validateCardNumber( $('#number').val() ) ){
      console.error("invalid credit card number");
      $("header > h1").text("credit card number is invalid");
      $('#number').addClass("invalid");
    } else {
      $('#number').removeClass("invalid");
    }
    if( !Stripe.validateCVC($('#cvc').val() ) ){
      $("header > h1").text("CVC is invalid");
      console.error("invalid cvc");
      $('#cvc').addClass("invalid");
    } else {
      $('#cvc').removeClass("invalid");
    }
    if( !Stripe.validateExpiry($('#month').val(), $('#year').val()) ) {
      console.error("invalid expiration")
      $("header > h1").text("Expiration date is invalid");
      $('#month').addClass("invalid");
      $('#year').addClass("invalid");
    } else {
      $('#month').removeClass("invalid");
      $('#year').removeClass("invalid");
    }
    if( $("#site_terms:checked").length == 0 ){
      $("header > h1 ").text("Do you agree to our terms of service?");
      console.error("must agree to terms");
      $('#site_terms').addClass("invalid");
    }else{
      $('#site_terms').removeClass("invalid");
    }

    
    if($('#credit_card .invalid').length > 0){
      console.debug('invalid');
      $('#credit_card input[type=submit]').removeAttr("disabled");
      return false;
    } else {
      $("header > h1").text("Working...");
    }

    Stripe.createToken({
      number: $('#number').val(),
      cvc: $('#cvc').val(),
      exp_month: $('#month').val(),
      exp_year: $('#year').val(),
      email: $('#email').val()
    }, $('#total_in_cents').val(), stripeResponseHandler);

    return false;
  });
});

function stripeResponseHandler(status, response) {
  console.debug(status, response);
  if (response.error) {
    //show the errors on the form
    $("header > h1 ").text(response.error.message);
    $('#credit_card input[type=submit]').removeAttr("disabled");
  } else {
    var form$ = $("#credit_card");
    // token contains id, last4, and card type
    var token = response['id'];
    // insert the token into the form so it gets submitted to the server
    form$.append("<input type='hidden' name='stripe_token' value='" + token + "'/>");
    // and submit
    form$.get(0).submit();
  }
}

