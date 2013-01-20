# Todo's
- Automatically posting your tips to facebook feed.

- Tip facebook pages via chrome

- Tests passing

- badge works for authors to embed 

- include honeybadger for javascript (so rad).

- Jobs scheduled   
-- Job for charging fans, 
-- job determining page authors running on production

---
<br>

# Later shit 

- Messaging
-- Newsletter for existing customers
--- Stuff you might like
-- Setting to turn of newsletter
-- welcome fans to the service
-- Welcome artists to the service
-- Order processing
--- artist welcome
--- artist onboarding

- second click of tip button should show detailed overlay
- Tiping cabin porn should work (JSON.parse is overwritten)

- Welcome page h1 should cycle through
-- (artist|creator|blogger|musician|veteran)

- email address
-- for ben, josh, laura

- Test facebook likes/stuff you might like against (some curated pages)

- First blog: copper manifesto
-- need to map what first 4, define what we want people to know. 

- Ben/Laura review EULA/Privacy Policy  
  
---

<br>

## Working inside the user agent(browser)
All javascript and css files are collected Into a single js/css file that each page loads. Javascript and css are namespaced. via the body tag

The body's id attribute is set to controller_action
    <body id="users_show">...</body>

_To change the background color of the fans profile page_
    #users_show {background-color: red}

_Each page can bind javascript to the page via:_
    $(document).on('load.controller_action',function (event){})  

_Bind a listener to the fans profile page load event_
    $(document).on('load.users_show',function (event){})
