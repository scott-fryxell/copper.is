jQuery ->
  $('body').fn.page_init()

  $(@).on 'load.endless', ->
    $(@).fn.page_init()

  new Endless()
  new Me()
  $(document).trigger "load.#{$('body').attr('id')}"
  $(document).trigger window.location.hash
