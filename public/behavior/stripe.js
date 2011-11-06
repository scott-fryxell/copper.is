// this identifies your website in the createToken call below
$(document).ready(function() {
  $("#edit_user").submit(function(event) {

    $('#edit_user > input').attr("disabled", "disabled"); // disable the submit button to prevent repeated clicks

    var amount_in_cents = 1000; //amount you want to charge in cents

    Stripe.createToken({
      number: $('#number').val(),
      cvc: $('#cvc').val(),
      exp_month: $('#month').val(),
      exp_year: $('#year').val()
    }, amount_in_cents, stripeResponseHandler);

    // prevent the form from submitting with the default action
    event.preventDefault();
  });
});

function stripeResponseHandler(status, response) {
  if (response.error) {
    //show the errors on the form
    $(".error_messages").html(response.error.message);
  } else {
    var form$ = $("#new_tip_order");
    // token contains id, last4, and card type
    var token = response['id'];
    // insert the token into the form so it gets submitted to the server
    form$.append("<input type='hidden' name='stripeToken' value='" + token + "'/>");
    // and submit
    form$.get(0).submit();
  }
}
