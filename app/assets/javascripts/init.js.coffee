jQuery ->
  $.fn.app_init($('body'))
  new Endless()
  new Me()
  $(document).trigger "load.#{$('body').attr('id')}"
  $(document).trigger(window.location.hash)
