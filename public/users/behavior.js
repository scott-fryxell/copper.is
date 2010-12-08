$(document).ready(function () {

  if (window.location.pathname == '/users/current/edit'){
    $('body').addClass('new_user');
  }

  var user_data_url = get_user_id(window.location.pathname) + ".json";
  
  $.get(user_data_url, function(data) {
    var tip_rate = data.user.tip_preference_in_cents
    var option = $('details#tip_rate > form > fieldset > select > option[value=' + tip_rate +']')
    option.attr('selected', true)
  });

  $('details > summary').click(function (event){
    if ($(this).parent('details').attr('open') == 'open')
      $(this).parent('details').attr('open', 'close')
    else
      $(this).parent('details').attr('open', 'open')
  });

  $('details#bookmarklet > p > a ').bind('dragend', function (event) {
    $('details#bookmarklet').removeClass('required');
    $('details#bookmarklet').addClass('completed');
    $('details#bookmarklet > summary').click();
  })

  $('details#tip_rate > form > fieldset > select').change(function (event) {
    $('details#tip_rate').removeClass('required');
    $('details#tip_rate').addClass('completed');
    $('details#tip_rate > summary').click();


    $.ajax({
      type: 'POST',
      url: $('details#tip_rate > form').attr('action'),
      data: $('details#tip_rate > form').serialize(),
    });

  });

});

function get_user_id(path){
  var i = path.indexOf('edit')
  
  return path.substring(0, i-1);
  
}

