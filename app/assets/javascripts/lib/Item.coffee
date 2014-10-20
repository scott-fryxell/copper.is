class @Item

  constructor: (@app_cache) ->
    console.log "load.#{$.page_scope()}"
    $(document).trigger "load.#{$.page_scope()}"


    # appcache only runs if you pass it an app cache at startup.
    if @app_cache

      $(@app_cache).on 'cashed', =>
        console.log @app_cache.status
        # window.location.reload()

      $(@app_cache).on 'updateready', =>
        if @app_cache.status == @app_cache.UPDATEREADY
          console.log @app_cache.status
          @app_cache.update()
          @app_cache.swapCache()
          # window.location.reload()

      @events = new EventSource('/events')
      document.events = @events

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
