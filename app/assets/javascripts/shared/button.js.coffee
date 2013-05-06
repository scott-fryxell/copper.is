$(document).on "load.home_getting_started load.home_settings", ->
  # set appropriate extension based on browswer type
  if $.browser.chrome
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
      $(document).trigger 'safari_button_downloaded'

  else if $.browser.mozilla
    $("a.install").click ->
      params = 
        "Copper tip button": 
          URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"
          IconURL: "https://www.copper.is/assets/icons/logo.svg"
          Hash: "sha1:e8e7f7427c7652ffc67a09b3f9335968caae5163"
          toString: -> "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"
      InstallTrigger.install params
      false;
  else
    $("a.install").hide();

$(document).on 'safari_button_downloaded', -> 
  $('#extension').addClass 'downloaded'

$(document).on 'copper_button_installed', ->
  # must be bound early for firefox onboarding to work.
  $('#extension').addClass 'installed'
  # TODO: refactor all this bullshit into class animations
  $('#home_index #button').delay(0).fadeOut 800
  $('#congrats').delay(800).fadeIn 800
  $('#facebook').delay(800).fadeIn 800
  $('#card').delay(800).fadeIn 800, ->
    $('#card > form input').first().focus()
