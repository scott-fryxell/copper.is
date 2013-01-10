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