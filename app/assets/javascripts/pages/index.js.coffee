$(document).on "load.pages_index", ->
  # determine what nav buttons are pressed and mark as selected
  $("nav > a[href='/pages#{window.location.search}']").addClass('selected')
  $("nav > a[href='#{window.location.hash}']").addClass('selected')