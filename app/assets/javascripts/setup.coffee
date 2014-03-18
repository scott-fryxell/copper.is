jQuery.fn.extend
  page_init: (element) ->
    $(element).find('time').timeago()
    $(element).find('[data-cents]').show_dollars(element)

# window.onerror =  (message, url, line) ->
#   Honeybadger.notify(new Error(message, url, line));
#   return true
