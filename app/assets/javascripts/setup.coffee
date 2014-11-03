jQuery.fn.extend
  app_init: ->
        
    $(@).find('time').timeago()
    $(@).find('[data-cents]').show_dollars(@)

    $(@).find('body > header > figure:first-of-type').click ->
      $(@).toggleClass('show')
      $('body > menu').toggleClass('show')

    $("menu.fan.signout > a").attr 'href',
      "/signout?redirect_to=#{window.location.pathname}"

    return true
