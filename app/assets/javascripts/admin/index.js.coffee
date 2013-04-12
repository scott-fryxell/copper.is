$(document).on "load.admin_index", ->
  $('nav#models > a').click ->
    event.preventDefault()
    $(@).toggleClass('selected')
    $("article#{$(@).attr('href')}").toggleClass('selected');

  $("details[itemscoped]").click ->
    unless $(@).attr('open')
      details = @
      jQuery.ajax
        url:$(@).attr('itemid'),
        success: (data) ->
          $(details).append(data)
        statusCode:
          401:->
            $(document).trigger "401"

      console.debug("getting data for #{}")


  $("#pallet").on 'drop', ->

    # Or else the browser will open the file
    event.preventDefault()

    data=event.dataTransfer.getData("Text");
    event.target.appendChild(document.getElementById(data));

  $("#pallet").on "dragover", ->
    event.preventDefault()
    console.debug("dragover")
    $(@).addClass("dragover")
    return false;

  $("#pallet").on "drop", ->
    event.preventDefault()
    console.debug("drop")
    $(@).addClass("drop")
    return false;


  $("#pallet").on "dragenter", ->
    event.preventDefault()
    console.debug("dragenter")
    $(@).addClass("dragenter")
    return false;

  $("#pallet").on "dragleave", ->
    event.preventDefault()
    console.debug("dragleave")
    $(@).addClass("dragleave")
    return false;


  $('[draggable]').on 'dragstart', ->
    # event.preventDefault()
    console.debug("dragstart")
    $(@).addClass("dragstart")
    # event.dataTransfer.setData("Text",event.target.id)

  $('[draggable]').on 'dragend', ->
    # event.preventDefault()
    console.debug("dragend")
    $(@).addClass("dragend")
    # event.dataTransfer.setData("Text",event.target.id)

  $('[draggable]').on 'drag', ->
    # event.preventDefault()
    console.debug("drag")
    $(@).addClass("drag")
    # event.dataTransfer.setData("Text",event.target.id)



    # <!DOCTYPE HTML>
    # <html>
    #   <head>
    #   <script>
    #     function allowDrop(ev)
    #     {
    #     ev.preventDefault();
    #     }

    #     function drag(ev)
    #     {
    #     ev.dataTransfer.setData("Text",ev.target.id);
    #     }

    #     function drop(ev)
    #     {
    #     ev.preventDefault();
    #     var data=ev.dataTransfer.getData("Text");
    #     ev.target.appendChild(document.getElementById(data));
    #     }
    #   </script>
    #   </head>
    #   <body>

    #     <div id="div1" ondrop="drop(event)" ondragover="allowDrop(event)">
          
    #     </div>

    #     <img id="drag1" src="img_logo.gif" draggable="true"
    #     ondragstart="drag(event)" width="336" height="69">

    #   </body>
    # </html>