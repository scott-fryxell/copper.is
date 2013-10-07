jQuery.fn.extend
  page_init: (element) ->
    $(element).find('time').timeago()
    $(element).find('[data-cents]').each -> $.fn.show_dollars(element)
    $.fn.discover_items(element)
