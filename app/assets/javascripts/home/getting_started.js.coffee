$(document).on "load.home_getting_started", ->
  if $.browser.safari 
    $("#home_getting_started > section").addClass('safari')
  else if $.browser.mozilla
    $("#home_getting_started > section").addClass('firefox')
  else
    $("#home_getting_started > section").addClass('chrome')
