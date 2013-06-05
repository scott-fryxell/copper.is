$(document).on "load.home_welcome", ->
  mixpanel.track('Guest welcome')