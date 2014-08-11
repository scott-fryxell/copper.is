$(document).on "load.pages.index", ->
  $("article[itemtype=page] figure").imgLiquid()

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
