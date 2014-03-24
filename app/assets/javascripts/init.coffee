$ ->
  $('html').page_init()

  $(@).on 'load.endless', ->
    $(@).page_init()

  new Me()
  new Endless()

  $(document).trigger "load.#{$('body').attr('class').replace(' ','.')}".trim()
  $(document).trigger "load.#{$('body').attr('id')}"

  window.onhashchange()

window.onhashchange = ->
  fragment = window.location.hash.substring(1)
  console.log "event: #{fragment}"
  $('body').toggleClass fragment
  $(document).trigger fragment

