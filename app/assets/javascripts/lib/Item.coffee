class @Item

  constructor: ->
    $(document).app_init()
    @app_cache = window.applicationCache
    @role = new Roles()

    console.log "load.#{$.page_scope()}"
    $(document).trigger "load.#{$.page_scope()}"

    $(@app_cache).on 'noupdate', =>
      @role.check()
      console.log "load.#{$.page_scope()}"
      $(document).trigger "load.#{$.page_scope()}"

    $(@app_cache).on 'updateready', =>
      @app_cache.update()
      @app_cache.swapCache()
      # console.info("#{window.location.href} body")
      $.get("#{window.location.pathname}").done (data) =>
        html = $.parseHTML(data)
        html = $(html).filter(':not(title, meta, link, script, style)')
        $('body').html(html)
        @role.check()
        $(document).app_init()
  
    @events = new EventSource('/events')

    $(@events).on "message", (event) =>
      console.info 'message from /events', event.data

    $(@events).on "open", (event) =>
      console.info 'bound to events server'

    $(@events).on "error", (event) =>
      console.error 'server event error:', event.data

    @events.addEventListener "page.save", (event) =>
      console.info 'refreshing appcash ', event.data
      @app_cache.update()
      @app_cache.swapCache()
