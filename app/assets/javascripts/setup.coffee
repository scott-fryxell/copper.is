jQuery.fn.extend
  page_init: (element) ->
    $(element).find('time').timeago()
    $(element).find('[data-cents]').show_dollars(element)

jQuery.ajaxPrefilter (options, originalOptions, xhr) ->
  unless options.crossDomain
    if token = $('meta[name="csrf-token"]').attr('content')
      xhr.setRequestHeader('X-CSRF-Token', token)

# window.onerror =  (message, url, line) ->
#   Honeybadger.notify(new Error(message, url, line));
#   return true
