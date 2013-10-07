jQuery.fn.extend
  page_init: (element) ->
    $(element).find('time').timeago()
    $(element).find('[data-cents]').each -> $.fn.show_dollars(element)
    $.fn.discover_items(element)

window.onerror =  (message, url, line) -> 
  Honeybadger.notify(new Error(message, url, line));
  return true
