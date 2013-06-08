$(document).on "load.pages_index", ->
  $('img.admin').click ->
    $('#admin').toggleClass('hide')
  $("#admin > nav > a[href='#{window.location.hash}']").addClass('selected')
  $("#admin > nav > a").click ->
      $(@).toggleClass('de-selected')
      $('#pages').toggleClass($(@).attr('href'))

