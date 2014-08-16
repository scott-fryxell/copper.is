class @Item

  constructor: (element) ->
    console.log "load.#{$.get_page_scope()}"
    $(element).trigger "load.#{$.get_page_scope()}"
