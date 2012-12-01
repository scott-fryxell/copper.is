
// Item.js is a library for utilizing the w3c's
// <a href="" >microdata</a> spec for html5 to support state
// changes  and dynamic object updates on a web page (similar 
// to backbone.js).  It can discover and dynamically manage 
// actions on a page based on their markup. the goal is to 
// determine and convert the elements on a page into 
// javascript objects and to manage them via a RESTfull api.
// The spec conforms pretty decent to this approach Item.js 
// goal is to reduce the amount of scaffolding javascript 
// that are required to manage data on an html page. At it's 
// core Item.js supports the View that their is a natural 
// MVC on user agents. M=html, V=CSS, C=javascript. While 
// data can travel back and forth via JSON, all pages are 
// loaded and what the data is, the object model, is 
// determined by the initial load of the html. 
// events are triggered when items are discoverd on the page
// when they are updated. and when there are erros on form submission, 
// and also when forms are submited succefully. 
Item = {
  items: {},

  // Determine what elements on the page are available to be managed. 
  discover_items: function(){
    $("*[itemscoped]").each(function (index){
      if(!Item.items[$(this).attr("itemtype")]){
        Item.items[$(this).attr("itemtype")] = []        
      }
      // each item must populate itemtype and itemId
      var i = {}
      i['id'] = $(this).attr('itemid'); 
      $(this).find("*[itemprop]").each(function (){
        if(Item.get_value(this)){
          i[$(this).attr('itemprop')] = Item.get_value(this);
        }
      });
      Item.items[$(this).attr("itemtype")].push(i);

    });
    if(Item.items){
      // let any listeners know that their are items on the page
      $(document).trigger("items." + $('body').attr('id'));
    }
    return Item.items;
  },

  get_value: function (element){
    if($(element).is("input") || $(element).is("textarea") || $(element).is("select")){
      if ($(element).val())
        return $(element).val().trim();
      else
        return 
    }
    else if( $(element).is("a") || $(element).is("link")){
      return $(element).attr('href');
    }
    else if( $(element).is("img") || $(element).is("object") || $(element).is("embed")){
      return $(element).attr('src');
    }
    else {
      if($(element).text()){
        return $(element).text().trim();
      }
    }
  },

  // update exsisting items on the page
  update_page: function(item){
    $.each(item, function(key, value){
      if(value != null){
        $('*[itemprop=' + key + ']').each(function(){
          if($(this).is("input") || $(this).is("select") || $(this).is("textarea") ){
            $(this).val(value);
          }
          else if( $(this).is("a") || $(this).is("link")){
            $(this).attr('href', value);
          }
          else if( $(this).is("img") ||  $(this).is("object") ||  $(this).is("embed")){
            $(this).attr('src', value);
          }
          else {
            $(this).text(value);
          }
        });
      }
    });
    // let any listeners know that the items on the page have been updated
    $(document).trigger('items.updated.' + $('body').attr('id'));
  },
  CSRFProtection: function (xhr){
    var token = $('meta[name="csrf-token"]').attr('content');
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  }
}
document.getItems = function (type){
  if(type){
    return Item.items[type]
  }
  else{
    return Item.items
  }
}
$(document).ready(function (event){
  $.ajaxPrefilter(function(options, originalOptions, xhr){ if ( !options.crossDomain ) { Item.CSRFProtection(xhr); }});

  Item.discover_items() //map all the items on the page into a javascript equivalent

  $(this).find("*[itemprop]") //todo why is this here?

  // capture form submissions for items. Determine
  // their values and submit the data via ajax. 
  // this means forms are submited with CSRF protection 
  // without requireing the forms themselves to know the token
  $("*[itemscoped] form").submit(function(event){
    event.preventDefault()

    // if their are no Items in the form just end the submit. 
    // this assumes that some other actor is going to be taking 
    // care of business 
    if($(this).find("*[itemprop]").length == 0 && 'delete' != $(this).attr('method')){
      return true
    }
    var item_element = $(this).parents('*[itemscoped]')
    var id = $(item_element).attr('itemid')
    var item_index = 0; // TODO get the index based on itemId
    var type = $(item_element).attr('itemtype')
    var form = this
    var item_rolback = Item.items[type][item_index] //if form fails we can rollback to the original state

    if ($(this).find('.invalid').size() > 0){
      //Do not submit the form if there are any invalid input fields
      return false;
    }

    // Update items on the page related to this form
    // Makes an optimistic assumption about form submission
    $(form).find('*[itemprop]').each(function (){
      if(Item.get_value(this)){
        Item.items[type][item_index][$(this).attr('itemprop')] = Item.get_value(this);
      }
    });
    Item.update_page(Item.items[type][item_index]);

    jQuery.ajax({
      url: $(this).attr('action'),
      type: $(this).attr('method'),
      data: $(this).serialize(),
      error: function(data, textStatus, jqXHR) {
        // let any listeners know that there was a problem with the form submit
        $(form).trigger('item.error');
        Item.items[type][item_index] = item_rolback;
        Item.update_page(Item.items[type][item_index]);
     
        console.error("error submiting item form " + id, data, textStatus, jqXHR);
      },
      success: function(data, textStatus, jqXHR){
        console.debug("successful item submission", data)
        //let any listeners know that any the form submited succesfully update.
        $(form).trigger('item.' + $(form).attr('method'));

        if( 'delete' == $(form).attr('method')){
          // TODO remove all instances of the Item on the page
          // Refresh the items for the page. This is inefficent
          Item.discover_items();
        }
      }
    });
  });
});
