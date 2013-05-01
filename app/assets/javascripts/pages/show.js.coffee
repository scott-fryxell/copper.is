$(document).on "load.pages_show", ->
  $('#admin > img.toggle').click ->
    $('#admin').toggleClass('hide');