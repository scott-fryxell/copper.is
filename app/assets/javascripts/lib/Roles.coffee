class @Roles

  constructor: ->
    @.check()

  check: ->
    console.info "checking for roles"
    $('body').attr("data-role", '')
    if $(document).items()['/me']?.admin?
      $('body').attr("data-role", 'admin')
      $(document).trigger "admin.#{$.page_scope()}"
    if $(document).items()['/me']?.fan?
      $('body').attr("data-role", 'fan')
      $(document).trigger "fan.#{$.page_scope()}"
    else
      $('body').attr("data-role", 'guest')
      $(document).trigger "guest.#{$.page_scope()}"
