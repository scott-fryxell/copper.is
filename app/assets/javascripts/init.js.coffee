jQuery ->
  $.fn.app_init($('body'))
  new Endless()
  $(document).trigger "load.#{$('body').attr('id')}"
  $(document).trigger(window.location.hash)

$(document).on 'load.endless', ->
  $(@).fn.page_init()
