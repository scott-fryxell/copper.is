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
        "Copper tip button": 
          URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi?"
          IconURL: "https://www.copper.is/assets/icons/logo.svg"
          Hash: "sha1:53b02499672a1babed411cf2cc06b33b55106fa6"
          toString: -> "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"
      InstallTrigger.install params
      false;
  else
    $("a.install").hide();
