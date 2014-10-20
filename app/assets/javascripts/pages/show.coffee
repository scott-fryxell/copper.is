$(document).on "load.pages.show", ->
  
  img = new Image()
  img.onload =  ->
    img_colors = Colibri.extractImageColors( img, 'css' )
    console.log img_colors
    $('main > section').background_color = img_colors.background

  img.crossOrigin = 'Anonymous'

  img.src = $("img[itemprop='thumbnail_url']").attr('src')
