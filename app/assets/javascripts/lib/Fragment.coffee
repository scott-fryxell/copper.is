class @Fragment

  constructor: ->
    window.onhashchange ->
      $('body').attr('id', '')
      fragment = window.location.hash.substring(1)
      console.log "event: #{fragment}"
      $('body').attr('id', fragment) # now you can style around the fragment event.
      $(document).trigger fragment
