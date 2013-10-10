$(document).on "load.pages_show", ->
  mixpanel.track 'View a Page'
  # page = document.items['pages'][window.location.pathname]

  if $.browser.chrome
    $('#banner > hgroup > figure').addClass('chrome')
  else if $.browser.mozilla
    $('#banner > hgroup > figure').addClass('mozilla')
  else
    $('#banner > hgroup > figure').addClass('safari')

