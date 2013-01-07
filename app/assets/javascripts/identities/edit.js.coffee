$(document).on "load.identities_edit", ->
  $('#user_nav').hide();

  $('body > nav > button').click ->

    $('#email form').trigger 'item.validate'
    $('#address form').trigger 'item.validate'

    if $('input.invalid').size() is 0 or  $('select.invalid').size() is 0  
      $(@).addClass 'working'
      jQuery.ajax
        url: '/users/me'
        type: 'put'
        data: $('form').serialize()
        error: ->
          alert 'There was a problem. Please verify your address and email then try again.'
          $('body > nav > button').removeClass 'working'
        success: -> window.location.pathname = '/author'