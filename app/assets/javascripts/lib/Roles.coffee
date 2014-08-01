class @Roles

  constructor: ->
    document.me = $.items().me
    if document.items?.me?.admin?
      $('body').attr("data-role", 'admin')
      $(document).trigger "admin.#{$.get_page_scope()}"
    if document.items?.me?.fan?
      $('body').attr("data-role", 'fan')
      $(document).trigger "fan.#{$.get_page_scope()}"
    else
      $('body').attr("data-role", 'guest')
      $(document).trigger "guest.#{$.get_page_scope()}"
