$(document).on "load.home_index", ->

  # set appropriate extension based on browswer type
  is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1
  if is_chrome
    $("a.install").click ->
      url = "https://chrome.google.com/webstore/detail/aoioappfaobhjafcnnajbndogjhaodpb"
      chrome.webstore.install url, ->
       $(document).trigger 'copper.button_installed'
      , (event) ->
        console.debug 'not working', event 
        alert event

  else if $.browser.safari 
    $("a.install").click ->
      $(this).attr "href", "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.safariextz"
      $(document).trigger 'copper.button_installed'

  else if $.browser.mozilla
    $("a.install").click ->
      params = 
        "Foo": 
          URL: "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi?",
          IconURL: "/assets/icons/logo.svg",
          Hash: "sha1:8e169c7ec8d5c2f21e5c6e2d1d173bedc001fe35",
          toString: -> "https://github.com/scott-fryxell/copper_extension/raw/master/compiled/copper.xpi"
      InstallTrigger.install params
      $(document).trigger 'copper.button_installed'
      false;
  else
    $("a.install").hide();
  
  # carousel the samples
  show_sample = (element) ->
    if 'nope' isnt $(element).attr 'data-distance' 
      $("#samples > nav > a").removeClass "selected"
      $(element).addClass "selected"
      $('#samples > figure').animate marginLeft: $(element).attr 'data-distance'
  
  $(document).on 'copper.button_installed', ->
    $('#join').delay(0).fadeOut 800 
    $('#congrats').delay(800).fadeIn 800
    $('#facebook').delay(800).fadeIn 800
    $('#settings').delay(800).fadeIn 800, ->
      $('#settings').delay(800).css "display",'block'
  
  $("#samples > nav > a").click ->
    event.preventDefault()
    clearInterval carousel
    show_sample @

  carousel = setInterval ->
    if "more" is $("#samples > nav > a.selected").next().attr('id')
      show_sample $("#samples > nav > a:first-child")
    else 
      show_sample $("#samples > nav > a.selected").next()
  , 5000

# if logged in display the the second step in the sign up process.
$(document).on "me.home_index", ->
  $('#join figure.step_one').hide()
  $('#join figure.step_two').show()

  facebook = -1
  for i of copper.me.identities 
    if copper.me.identities[i].provider == 'facebook'
      facebook = copper.me.identities[i]

  if facebook
    likes_url = "https://graph.facebook.com/#{facebook.username}/likes?limit=10&access_token=#{facebook.token}"
    me_url = "https://graph.facebook.com/me?&access_token=#{facebook.token}"

    $.getJSON(likes_url).success (facebook) ->
      $.each facebook.data, (i, a_like) ->
        $.getJSON("https://graph.facebook.com/#{a_like.id}").success (like) ->
          image = $('<img/>', src:"https://graph.facebook.com/#{like.id}/picture")
          $('<a/>', {href:like.link, html:image}).appendTo('#facebook > nav')

    $.getJSON(me_url).success (me) -> $('figure.step_two > h5 > p').append "Welcome, #{me.first_name}!"
