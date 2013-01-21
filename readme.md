Todo's
======
- Automatically posting your tips to facebook feed.
- Tip facebook pages via chrome
- Tests passing
- Badge works for authors to embed 
- Include honeybadger for javascript (so rad)
- Jobs scheduled
    - Charging fans 
    - copper:pages:adopt running on production

Later shit
==========
- Messaging
    - Newsletter for existing customers
        - Stuff you might like
    - Setting to turn of newsletter
    - welcome fans to the service
    - Welcome artists to the service

- Order processing
    - artist welcome
    - artist onboarding

- Second click of tip button should show detailed overlay
- Tiping cabin porn should work (JSON.parse is overwritten)

- Welcome page h1 should cycle through
    - (artist|creator|blogger|musician|veteran)

- email address
    - for ben, josh, laura

- Test facebook likes/stuff you might like against (some curated pages)

- First blog: copper manifesto
    - need to map what first 4 entries

- Ben/Laura review EULA/Privacy Policy  
  
---


The user agent
==============

All javascript and css files are collected Into a    
single js/css file that is instanceated (from cache) for     
each page load. Javascript and css are namespaced.    
via the body tag    

The body's id attribute is set to controller_action
```html
<body id="users_show">...</body>
```

To change the background color of the fans profile page
```css
#users_show {
  background-color: red
}
```

Each page can bind javascript to the page
```javascript
$(document).on('load.controller_action',function (event){})  
```

Bind a listener to the fans profile page load event
```javascript
$(document).on('load.users_show',function (event){})
```