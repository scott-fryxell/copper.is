$ ->

  # log
  console.log('initializing app', @)

  # bind
  $(@).on 'load.endless', -> $(@).page_init()

  # trigger
  $('html').page_init()

  new Item($('html'))
  new Roles()
  # new Endless()
  # new Fragment()
