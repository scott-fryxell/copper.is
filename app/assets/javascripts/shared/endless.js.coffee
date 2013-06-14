class Endless

  constructor: ->
    document.endless = @
    @page = 1
    @check = false

    if $('section.endless').length
      $('body').on 'load.endless', document.endless.next
      setInterval(document.endless.wait, 500)
      $(window).scroll ->
        if document.endless.check
          document.endless.check = false
          console.debug('window.scroll')
          if $(window).scrollTop() > $(document).height() - $(window).height() - 250
            $('body').trigger('load.endless')

  next: =>
    @page++
    console.debug("load_next_page", @page)
    $('body').off 'load.endless', document.endless.next

    jQuery.get "#{window.location}?endless=#{@page}",  (data) ->
      $('body > footer').before(data);
      # console.debug("huh", data )
      if $('section.endless').last().html().trim().length
        $('body').on 'load.endless', document.endless.next
      else
        $('section.endless').last().remove()
        clearInterval(document.endless.wait)
        console.debug("you aint got no content")

  wait: =>
    @check = true

$(document).ready ->
  console.debug('endless setup')
  new Endless()