class @Me
  constructor: ->
    @.me = $('body > data').items().me

    if @.me
      if @.me.admin
        $('body').addClass("admin")
        $(document).trigger "admin.#{$('body').attr('id')}"
        $('#admin > img.toggle').click ->
          $('#admin').toggleClass('hide')
      if @.me.fan
        $('body').addClass("fan")
        $(document).trigger "me.#{$('body').attr('id')}"
    else
      $('body').addClass("guest")
      $(document).trigger "guest.#{$('body').attr('id')}"

    return @.me
