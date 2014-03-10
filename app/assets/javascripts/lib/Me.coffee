class @Me
  constructor: ->
    @.me = $('body > data').discover_items().me
    console.log "me", @.me
    if @.admin
      $('body').addClass("admin")

      $('#admin > img.toggle').click ->
        $('#admin').toggleClass('hide')

    if @.fan
      $('body').addClass("fan")
      $(document).trigger "me.#{$('body').attr('id')}"
    else
      $('body').addClass("guest")
      $(document).trigger "guest.#{$('body').attr('id')}"
