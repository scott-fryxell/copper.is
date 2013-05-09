$(document).on "load.pages_show", ->
  page = document.items['pages'][window.location.pathname]

  if $.browser.chrome
    $('#banner > figure').addClass('chrome')
  else if $.browser.mozilla
    $('#banner > figure').addClass('mozilla')
  else
    $('#banner > figure').addClass('safari')