#= require jquery
#= require jquery.cookie
#= require jquery.timeago
#= require jquery.tmpl
#= require jquery.details
#= require shared/Item
#= require shared/copper
#= require shared/install
#= require shared/address
#= require shared/card
#= require shared/email
#= require home/index
#= require home/author
#= require home/settings
#= require home/welcome
#= require authors/edit
#= require honeybadger.min
Honeybadger.configure({api_key: 'df5151fb675d4d4af78d117fab648540'});

$(document).on 'copper_button_installed', ->
  # must be bound early for firefox onboarding to work.
  $('#install').delay(0).fadeOut 800 
  $('#congrats').delay(800).fadeIn 800
  $('#facebook').delay(800).fadeIn 800
  $('#card').delay(800).fadeIn 800, ->
    $('#card > form input').first().focus()

$(document).ready ->
  jQuery('time').timeago();
  $(document).trigger "load." + $('body').attr 'id'

  jQuery.ajax
    url:'/users/me.json',
    dataType:'json',
    success: (data) ->
      document.copper.me = data;
      Item.update_page document.copper.me
      $('img.author').attr 'src', document.copper.get_author_image()
      $("#user_nav").addClass 'show'
      $('a[href="/signout"]').css 'display','inline-block'
      $(document).trigger "me." + $('body').attr 'id'
    statusCode:
      401:->
        $(document).trigger "guest." + $('body').attr 'id'
    
  $(document).bind 'save.me', ->
    jQuery.ajax
      dataType:'json'
      url: '/users/me.json'
      type: 'put'
      data: jQuery.param document.copper.me 
      error: -> $(document).trigger "error.me"