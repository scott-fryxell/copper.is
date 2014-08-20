jQuery.fn.extend
  app_init: ->
    $(@).find('time').timeago()
    $(@).find('[data-cents]').show_dollars(@)

    $(@).find('body > header > figure:first-of-type').click ->
      $(@).toggleClass('show')
      $('body > menu').toggleClass('show')
