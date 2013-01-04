#= require jquery
#= require jquery.cookie
#= require jquery.timeago
#= require jquery.tmpl
#= require jquery.details
#= require shared/Item
#= require shared/address
#= require shared/copper
#= require shared/email
#= require home/index
#= require home/author
#= require home/settings
#= require home/welcome
#= require identities/edit

$(document).ready ->
  jQuery('time').timeago();
  $(document).trigger "load." + $('body').attr 'id'

  $("#sign_in > nav > a").hover(
    ->
      $(@).find("img").hide()
      $(@).find("img.hover").show()
    ->
      $(@).find("img").show()
      $(@).find("img.hover").hide()
  )

  $("img[alt=Gear]").click -> $(@).addClass "working"

  jQuery.ajax
    url:'/fans/me.json',
    dataType:'json',
    success: (data) ->
      document.copper.me = data;
      Item.update_page document.copper.me
      $('img.identity').attr 'src', document.copper.get_identity_image()
      $("#signed_in").addClass 'show'
      $('a[href="/signout"]').css 'display','inline-block'
      $(document).trigger "me." + $('body').attr 'id'
    statusCode:
      401:->
        $("#sign_in").addClass 'show'
        $("#sign_in > nav > a > img").click -> $(@).addClass "working"
        $(document).trigger "guest." + $('body').attr 'id'
    
  $(document).bind 'save.me', ->
    jQuery.ajax
      dataType:'json'
      url: '/fans/me.json'
      type: 'put'
      data: jQuery.param copper.me 
      error: -> $(document).trigger "error.me"