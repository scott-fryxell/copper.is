#= require jquery
#= require jquery.cookie
#= require jquery.timeago
#= require jquery.tmpl
#= require jquery.details
#= require shared/Item
#= require shared/form
#= require shared/email
#= require shared/address
#= require shared/copper
#= require home/index
#= require users/edit
#= require users/show
#= require authors/show
#= require authors/edit
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
      copper.me = data;
      Item.update_page copper.me
      $('img.identity').attr 'src', copper.get_identity_image()
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