jQuery.fn.extend
  page_init: ->
    $(@).find('time').timeago()
    $(@).find('[data-cents]').show_dollars(@)

jQuery.get_page_scope = ->
    "#{$('body').attr('class').replace(' ','.')}".trim()

window.onhashchange = ->
  $('body').attr('id', '')
  fragment = window.location.hash.substring(1)
  console.log "event: #{fragment}"
  $('body').attr('id', fragment) # now you can style around the fragment event.
  $(document).trigger fragment
