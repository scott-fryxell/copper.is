$(document).on "load.home_getting_started", ->
  if $.browser.safari 
    $("section#step_two").addClass('safari')
  else if $.browser.mozilla
    $("section#step_two").addClass('firefox')
  else
    $("section#step_two").addClass('chrome')
