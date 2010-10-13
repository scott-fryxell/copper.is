$(document).ready(function(event) {
  $("select[id=order_amount_in_cents]").focus();

  $("select[id=order_amount_in_cents]").change(function(event) {
    var tip_stash = new Number(this.value);
    var shakedown =  (tip_stash / 10 *.70);
    $("fieldset#budget > #fee").text( "$" + (Math.round(shakedown) / 100).toFixed(2));
    $("fieldset#budget > #total").text( "$" + (( tip_stash + shakedown) /100 ).toFixed(2));
  });

  $("select[id=order_amount_in_cents] option[value=1000]").attr('selected', 'selected');
  $("select[id=order_amount_in_cents]").change();
});