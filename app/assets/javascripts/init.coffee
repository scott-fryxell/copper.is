$ ->

  $('body > header > figure').click ->
    console.info('toggler')
    $('body > menu').toggleClass('show')

  # log
  console.log('initializing app', @)

  # bind
  $(@).on 'load.endless', -> $(@).page_init()

  # trigger
  $('html').page_init()

  new Item(document)
  new Roles()
  # new Endless()
  # new Fragment()
