$(document).on "load.pages.recent", ->

  console.log 'recently tipped pages'

  $("article[itemtype=page] figure").imgLiquid()
