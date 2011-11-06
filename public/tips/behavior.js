window.parent.postMessage("reset_frame",  "*");

$(document).ready(function() {
  
  $("input[name='authenticity_token']").val($('meta[name=csrf-token]').attr('content'));
  $.get('/users/current.json', function(data) {
    var tip_rate = data.user.tip_preference_in_cents
    var option = $('form#tip_rate > select > option[value=' + tip_rate +']')
    option.attr('selected', true)
  });

  $('form#tip_rate > select').change(function (event) {
    $('form#tip_rate').removeClass('required');
    $('form#tip_rate').addClass('completed');
    $('form#tip_rate > summary').click();

    $.ajax({
      type: 'POST',
      url: $('form#tip_rate').attr('action'),
      data: $('form#tip_rate').serialize(),
    });
  });

  $('td > form').bind('submit', function(){
    $(this).parent().parent().addClass('destroyed');
  });

  jQuery('time').timeago();

});


$(document).bind("#current_tips", function(event){
  // 
});

$(document).bind("#active_tips", function(event){
  // display all the active tips
});
