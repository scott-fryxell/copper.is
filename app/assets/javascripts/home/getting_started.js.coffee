$(document).on "load.home_getting_started", ->

  $(document).on '#one_of_us',  ->
    document.brand_new_fan = true
    window.location.hash = ""

  if $.browser.safari
    $("section#step_two").addClass('safari')
  else if $.browser.mozilla
    $("section#step_two").addClass('firefox')
  else
    $("section#step_two").addClass('chrome')

  $("#step_two a.button").click ->
    mixpanel.track 'Try to install button'

  $("#card").on 'credit_card_approved', ->
    mixpanel.track 'Save credit card'
    window.location = "/tip_some_pages"

$(document).on "me.home_getting_started", ->
  if document.brand_new_fan
    mixpanel.track 'Fan created'

$(document).on "guest.home_getting_started", ->
  mixpanel.track 'Learn how the service works'