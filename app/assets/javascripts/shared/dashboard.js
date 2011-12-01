$(document).on("get:current_user", function () {
  console.debug("current user", current_user.tip_preference_in_cents);
  $('form#tip_rate > select > option[value=' + current_user.tip_preference_in_cents +']').attr('selected', true)

  $('form#tip_rate > select').change(function (event) {
    $.ajax({
      type: $('form#tip_rate').attr("method"),
      url: $('form#tip_rate').attr('action'),
      data: $('form#tip_rate').serialize(),
    });
  });
});
