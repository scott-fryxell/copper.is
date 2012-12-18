$(document).on "load.identities_edit load.users_edit load.authors_edit", ->

  $('#email form').bind 'item.error', ->
    $('#email > header > a').click();
    $(this).find('input[itemprop=email]').addClass 'invalid';

  $('#email form').on "item.validate", ->
    $('#email input').removeClass "invalid"
    email = $('input[itemprop=email]').val()
    if ( email.search(/\./) == -1 || email.search('@') == -1 || email.indexOf('@') < 2  )
      $('input[itemprop=email]').addClass 'invalid'

$(document).on "load.users_edit load.authors_edit", ->

  # assume the other validations have run. so if we're good 
  # then change the email for display
  $('#email form').on "item.validate", ->
    unless $('#email form .invalid').size == 0
      $('#email p[itemprop=email]').text($(this).find('input[itemprop=email]').val())
