$ ->
  # log
  console.log('initializing app', @)

  $('body > header > figure > svg').click ->
    if $(@).attr('class') == 'show'
      $(@).attr("class", "")
      $(@).find('use').attr("class", "")
    else
      $(@).attr("class", "show")
      $(@).find('use').attr("class", "show")

    $('body > menu').toggleClass('show')

  # bind
  $(@).on 'load.endless', -> $(@).page_init()

  # trigger
  $('html').page_init()

  new Item(document)
  new Roles()
  # new Endless()
  # new Fragment()
