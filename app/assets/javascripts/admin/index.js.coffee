$(document).on "load.admin_index", ->
  $('nav#models > a').click ->
    event.preventDefault()
    $(@).toggleClass('selected')
    $("article#{$(@).attr('href')}").toggleClass('selected');