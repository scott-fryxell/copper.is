$(document).on "load.pages_index", ->
  $('img.admin').click ->
    $('section.admin').toggleClass('hide')
  $("section.admin > nav > a[href='#{window.location.hash}']").addClass('selected')
  $("section.admin > nav > a").click ->
      $(@).toggleClass('de-selected')
      $('#pages').toggleClass($(@).attr('href'))

