class @Item

  constructor: (@app_cache) ->
    console.log "load.#{$.get_page_scope()}"
    $(document).trigger "load.#{$.get_page_scope()}"


    # appcache only runs if you pass it an app cache at startup.
    if @app_cache
      console.log('initializing app', @app_cache)
      console.debug @app_cache
      $(@app_cache).on 'updateready', =>
        if @app_cache.status == @app_cache.UPDATEREADY
          console.log 'cache update ready'
          @app_cache.update()
          console.log 'swap ready'
          @app_cache.swapCache()
          window.location.reload()

      $(@app_cache).on 'noupdate', ->
        new Roles()
        # new Endless()
        # new Fragment()
