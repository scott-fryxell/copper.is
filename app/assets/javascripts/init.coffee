$ ->
  $('body').page_init()

  $(@).on 'load.endless', ->
    $(@).page_init()

  document.me = new Me()
  new Endless()

  $(document).trigger "load.#{$('body').attr('class').replace(' ','.')}".trim()
  $(document).trigger "load.#{$('body').attr('id')}"
  $(document).trigger window.location.hash

window.onhashchange = ->
  $(document).trigger window.location.hash
