$ ->
  $('html').page_init()

  new Me()
  new Endless()

  console.log(@)

  $(@).on 'load.endless', ->
    $(@).page_init()

  $(@).trigger "load.#{$.get_page_scope()}"

  window.onhashchange()
