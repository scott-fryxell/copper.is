class @Roles

  constructor: ->
    document.me = $.items().me
    if document.items?.me?.admin?
      $('body').attr("data-admin", true)
      $(document).trigger "admin.#{$.get_page_scope()}"
    if document.items?.me?.fan?
      $('body').attr("data-fan", true)
      $(document).trigger "fan.#{$.get_page_scope()}"
    else
      $('body').attr("data-guest", true)
      $(document).trigger "guest.#{$.get_page_scope()}"
