$ ->
  # log
  console.log('initializing app', @)

  $('body > header > figure > svg').click ->
    $(@).toggleClass('show')
    $('body > menu').toggleClass('show')

  # bind
  $(@).on 'load.endless', -> $(@).page_init()

  # trigger
  $('html').page_init()

  new Item(document)
  new Roles()
  # new Endless()
  # new Fragment()
