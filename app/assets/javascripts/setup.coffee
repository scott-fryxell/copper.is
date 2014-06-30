jQuery.fn.extend
  page_init: ->
    $(@).find('time').timeago()
    $(@).find('[data-cents]').show_dollars(@)

jQuery.get_page_scope = ->
    "#{$('body').attr('class').replace(' ','.')}".trim()

window.onhashchange = ->
  fragment = window.location.hash.substring(1)
  console.log "event: #{fragment}"
  $('body').toggleClass fragment
  $(document).trigger fragment
