jQuery.fn.extend
  page_init: ->
    $(@).find('time').timeago()
    $(@).find('[data-cents]').show_dollars(@)
