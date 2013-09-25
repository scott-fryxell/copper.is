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

// The Item data is defined by what's on the page, in the dom
// not what's being maintained in a seperate javascript object.
// every time you access the items on the page this state is re-created
// from the dom.
document.getItems = function (type){
  if(type){
    return Item.items[type]
  }
  else{
    return Item.items
  }
}
$("[itemscope] form, [itemref] form").submit(function(event){
  // capture form submissions for items. Determine
  // their values and submit the data via ajax.
  // this means forms are submited with CSRF protection
  // without requireing the forms themselves to know the token
  // The form is only submited if there are elements with
  // itemprop set

  event.preventDefault()

  // if their are no Items in the form just end the submit.
  // this assumes that some other actor is going to be taking
  // care of business
  if($(this).find("[itemprop]").length == 0 && 'delete' != $(this).attr('method')){
    return true
  }
  var item_element = $(this).parents('[itemscope], [itemref]')
  if ( $(item_element).attr('itemid')){
    var id = $(item_element).attr('itemid')
  }else {
    var id = $(item_element).attr('itemref')
  }

  var item_index = 0; // TODO get the index based on itemId
  var type = $(item_element).attr('itemtype')
  var form = this
  // var item_rolback = Item.items[type][item_index] //if form fails we can rollback to the original state
  var action = $(this).attr('action');

  if(!action){
    // determine the action from the itemscope
    action = id
  }
  var method = $(this).attr('method').toLowerCase();

  $(form).trigger('item.validate');

  if ($(form).find('.invalid').size() > 0){
    //Do not submit the form if there are any invalid input fields
    return false;
  }

  jQuery.ajax({
    url: action,
    type: method,
    data: $(this).serialize(),
    error: function(data, textStatus, jqXHR) {
      // let any listeners know that there was a problem with the form submit
      $(form).trigger('item.error');
      // Item.items[type][item_index] = item_rolback;
      Item.update_page(Item.items[type][item_index]);
      console.error("error submiting item form " + id, data, textStatus, jqXHR);
    },
    success: function(data, textStatus, jqXHR){
      // let any listeners know that any the form submited succesfully update.
      // TODO we leave updating the items to the listener of this method. this is risky
      $(form).trigger('item.' + method, [data, textStatus, jqXHR]);
    }
  });

  //don't submit the form so that the page redraws
  return false;
});
$(document).ready(function (event){
  jQuery.ajaxPrefilter(function(options, originalOptions, xhr){ if ( !options.crossDomain ) { $.fn.CSRFProtection(xhr); }});

  if($.fn.discover_items()){
    // let any listeners know that their are items on the page
    $(document).trigger("items." + $('body').attr('id'));
  }
});

(function($) {
  $.fn.extend({
    discover_items: function(element){
      // Determine what elements on the page
      // are available to be managed.
      $("*[itemscope]").each(function (index){
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
      return Item.items;
    },
    get_value: function (element){
      if($(element).is("input") || $(element).is("textarea") || $(element).is("select")){
        if ($(element).val())
          return $(element).val().trim();
        else
          return ""
      }
      else if ($(element).attr('data-value')){
        return $(element).attr('data-value');
      }
      else if( $(element).is("a") || $(element).is("link")){
        return $(element).attr('href');
      }
      else if( $(element).is("img") || $(element).is("object") || $(element).is("embed")){
        return $(element).attr('src');
      }
      else if( $(element).is("meta")){
        return $(element).attr('content');
      }
      else if( $(element).is("time")){
        return $(element).attr('datetime');
      }
      else {
        if($(element).text()){
          return $(element).text().trim();
        }
      }
    },
    update_page: function(item){
      // update exsisting items on the page itemid
      // is assumed to be unique identifier
      $.each(item, function(key, value){
        if(value != null){
          $('[itemprop=' + key + ']').each(function(){
            if($(this).is("input") || $(this).is("select") || $(this).is("textarea") ){
              $(this).val(value);
            }
            else if ($(this).attr('data-value')){
              $(this).attr('data-value', value)
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
            $(this).trigger('item.changed');
          });
        }
      });
    },
    CSRFProtection: function (xhr){
      var token = $('meta[name="csrf-token"]').attr('content');
      if (token) xhr.setRequestHeader('X-CSRF-Token', token);
    }
  });
})(jQuery);


