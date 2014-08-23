class @Item

  constructor: (@app_cache) ->
    console.log "load.#{$.get_page_scope()}"
    $(document).trigger "load.#{$.get_page_scope()}"
    new Roles()
    # new Endless()
    # new Fragment()
    @server_events = new EventSource('/events')


    # appcache only runs if you pass it an app cache at startup.
    if @app_cache
      console.log('initializing app', @app_cache)

      $(@app_cache).on 'cashed', =>
        console.log @app_cache.status
        # console.log 'cached'
        window.location.reload()

      $(@app_cache).on 'updateready', =>
        if @app_cache.status == @app_cache.UPDATEREADY
          console.log 'cache update ready'
          @app_cache.update()
          console.log 'swap ready'
          @app_cache.swapCache()
          window.location.reload()

      console.info 'binding to cache events'
      $(@server_events).on 'refresh_cache', =>
        console.info('appcache updated')
        @app_cache.update()
        @app_cache.swapCache()
