class @Endless

  constructor: ->
    document.endless = @
    @page = 1
    @check = false
    @height = $('body > main').height()
    # TODO: add a check for current scroll down the page and a distance gate
    # that will need to be triggerd before another endless attempt is made
    # do not retrigger endless if the height hasn't changed
    $('input[type=range].endless').change ->
      for column in ['2','3','4','6','8','12']
        if column is @.value
          $('section.endless').attr('data-per-row', @.value)

    if $('section.endless').length

      $('body').on 'next.endless', document.endless.next
      setInterval(document.endless.wait, 3000)
      $(window).scroll ->
        if document.endless.check
          document.endless.check = false
          if $(window).scrollTop() > $(document).height() - $(window).height() - 350
            $('body').trigger('next.endless')

    $(window).scroll()

  next: =>
    @page++
    # console.debug("load_next_page", @page)
    $('body').off 'load.endless', document.endless.next

    jQuery.get "#{window.location}/endless/#{@page}",  (data) ->
      $('body > footer').before(data);
      $('body:last-child').trigger('load.endless')
      if $('section.endless').last().html().trim().length
        $('body').on 'next.endless', document.endless.next
      else
        $('section.endless').last().remove()
        clearInterval(document.endless.wait)

  wait: =>
    @check = true
