$(document).on "load.home_index load.home_tipped", ->
  $("#tip").focus ->
    $("#tip").attr("placeholder", "Paste to tip")

  $("#tip").blur ->
    $("#tip").attr("placeholder", "Tip")

$(document).on '#latest_tip', ->
  $('#pages > details:first-of-type > summary').click()

