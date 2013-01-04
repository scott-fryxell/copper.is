$(document).on "load.identities_edit load.home_settings", ->

  $('#email form').bind 'item.error', ->
    $('#email > header > a').click();
    $(@).find('input[itemprop=email]').addClass 'invalid'

  $('#email form').on "item.validate", ->
    $('#email input').removeClass "invalid"
    email = $('input[itemprop=email]').val()
    if ( email.search(/\./) is -1 || email.search('@') is -1 || email.indexOf('@') < 2  )
      $('input[itemprop=email]').addClass 'invalid'

$(document).on "load.home_settings", ->
  # assume the other validations have run. so if we're good 
  # then change the email for display
  $('#email form').on "item.validate", ->
    unless $('#email form .invalid').size is 0
      $('#email p[itemprop=email]').text($(@).find('input[itemprop=email]').val())
