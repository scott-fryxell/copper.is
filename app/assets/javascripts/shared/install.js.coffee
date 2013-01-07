$(document).on "load.home_index load.home_settings", ->

  # set appropriate extension based on browswer type
  is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1
  if is_chrome
    $("a.install").click ->
      url = "https://chrome.google.com/webstore/detail/aoioappfaobhjafcnnajbndogjhaodpb"
      chrome.webstore.install url, ->
       $(document).trigger 'copper_button_installed'
      , (event) ->
        console.error 'not working', event 
        alert event

  else if $.browser.safari 
    $("a.install").click ->
      $(@).attr "href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.safariextz"
      $(document).trigger 'copper_button_installed'

  else if $.browser.mozilla
    $("a.install").click ->
      params = 
        "Foo": 
          URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi?"
          IconURL: "/assets/icons/logo.svg"
          Hash: "sha1:8e169c7ec8d5c2f21e5c6e2d1d173bedc001fe35"
          toString: -> "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"
      InstallTrigger.install params
      $(document).trigger 'copper_button_installed'
      false;
  else
    $("a.install").hide();
