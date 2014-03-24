$(document).on "load.home_index load.home_tipped", ->
  $("#tip").focus ->
    $("#tip").attr("placeholder", "Paste to tip")

  $("#tip").blur ->
    $("#tip").attr("placeholder", "Tiped!")
    $("#tip").val("")

$(document).on 'view_latest_tip', ->
  $('#pages > details:first-of-type > summary').click()

$(document).on "paste", (e) ->
  $('body').addClass('working')
  url =  e.originalEvent.clipboardData.getData('text/plain')
  console.log url
  $("#tip").blur()

# Switch back to tip view in 3.seconds switch to


