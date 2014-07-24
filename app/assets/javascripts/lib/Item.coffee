class @Item

  constructor: (element) ->
    $(element).trigger "load.#{$.get_page_scope()}"
