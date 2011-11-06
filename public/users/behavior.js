window.parent.postMessage("reset_frame",  "*");
$(document).ready(function () {
  $.get('/users/current.json', function(data) {
    var tip_rate = data.user.tip_preference_in_cents
    var option = $('#tip_rate > form > fieldset > select > option[value=' + tip_rate +']')
    option.attr('selected', true)
    $('#tip_rate > form').attr('action', '/users/' + data.user.id)
  });

  $('div > summary').click(function (event){
    console.debug('display summary');
    if ($(this).parent('div').attr('open') == 'open')
      $(this).parent('div').attr('open', 'close')
    else
      $(this).parent('div').attr('open', 'open')
  });

  $('#bookmarklet > a ').bind('dragend', function (event) {
    $('#bookmarklet').removeClass('required');
    $('#bookmarklet').addClass('completed');
    $('#bookmarklet > summary').click();
  })

  $('#tip_rate > form > fieldset > select').change(function (event) {
    $('#tip_rate').removeClass('required');
    $('#tip_rate').addClass('completed');
    $('#tip_rate > summary').click();

    $.ajax({
      type: 'POST',
      url: $('#tip_rate > form').attr('action'),
      data: $('#tip_rate > form').serialize(),
    });

  });

});
