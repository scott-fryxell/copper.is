$(document).on "load.identities_edit items.fans_edit load.authors_edit", ->
  $('#email form').bind 'item.error', ->
    $('#email > header > a').click();
    $(this).find('input[itemprop=email]').addClass 'invalid';

  $('#email form').submit ->
    $(document).trigger('form.validate_email')
    # validate email locally

$(document).on "form.validate_email", ->
  $('#email input').removeClass("invalid");

  $('#email input').removeClass "invalid"
  email = $('input[itemprop=email]').val()
  if ( email.search(/\./) == -1 || email.search('@') == -1 || email.indexOf('@') < 2  )
    $('input[itemprop=email]').addClass 'invalid'
