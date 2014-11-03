$(document).on "load.pages.trending", ->
  console.log 'trending pages'
  $("article[itemtype=page] figure").imgLiquid()
