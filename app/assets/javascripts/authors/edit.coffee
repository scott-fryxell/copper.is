$(document).on "load.authors_edit", ->
  $('body > nav > button').click ->

    $('#email form').trigger 'item.validate'

    if $('input.invalid').size() is 0 or  $('select.invalid').size() is 0
      $(@).addClass 'working'
      jQuery.ajax
        url: '/users/me'
        type: 'put'
        data: $('form').serialize()
        error: -> $('body > nav > button').removeClass 'working'
        success: -> window.location.pathname = '/author'
