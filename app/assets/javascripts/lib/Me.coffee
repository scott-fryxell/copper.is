class @Me
  constructor: ->
    document.me = $.items().me
    if document.items?.me?.admin?
      $('body').addClass("admin")
      $(document).trigger "admin.#{$('body').attr('id')}"
    if document.items?.me?.fan?
      $('body').addClass("fan")
      $(document).trigger "fan.#{$('body').attr('id')}"
    else
      $('body').addClass("guest")
      $(document).trigger "guest.#{$('body').attr('id')}"

