#  I'm  about to force a fifteen year old girl to learn how to code

This is the framework i'm going to make her learn.

I'll know she's sorted when she can build me a web app with this framework. She'll have learned the fundamentals to build any thing she wants.

No nerd required.

She's an asshole, like a fifteen year old girl going to an art school, in a drug soaked city kind of asshole. 

It has to be simple. It has to be capable. it has to be intuitive. 

She should think in html.

She should only have to think about html in three different ways – A **domain**, a **collection**, and **member**.

So it's not gonna fly unless I strip out all the bullshit that goes for web development these days. If she knows the tag she should be able to get the functionality.

# Just learn html css and coffee
Tt's designed to be a natural way for people to think about coding for the web. Frameworks like react.js and backbone are tyring to enforce a native app mindset on the web.

This is a framework for the web.

# Context is everything

The web provides for three natural scopes from which to build a framework

  web-context = [
    domain:     ['/',          :itemscope],
    collection: ['/pages',     :itemtype],
    member:     ['/pages/:id', :itemid]
  ]


we adhear to this context throughout the framework.  we scope both javascript and css to one of these contexts

```
  <body class='pages index'>
    ...

  <style>
    body.pages.index {
      background-color:hsla( 35,  62%, 56%, 0.99);
    }

  <script>
    $('body.pages.index').on 'load',  ->
      ...
```

State is managed by Item.js. which can init with or without an element.
	 new Item()

  without an element it will get all the items on a page and
  manage their state.

actually that's not the deal. you just include the appropriate javascript and it will manage state by binding to a set of conventions tied directly to itemscope, itemtype and itemid.

# Testing

this framework persists it's concept of a model in the html.
there are no objects maintained in javascript.

testing should be based around html. it's counter to most testing frameworks.

but it's the context within which all interactivity and state is based.

```
  gospel = {
    model::html
    view::css
    controller::script
  }  
```

you test your code in javascript. but the test framework get's it's state from [itemscope,itemtype,itemid]

# fuck the app store

With this framework there is no longer a speed advantage for native applications.

It's built around user agent (browser) appcache.

and through intelliegent server_events returns us to the ability to create page driven web apps that have the performance of native applications.

Do they really need %30 of your revenue?

# nobody likes you JSON.

since there are not models in javascript there is not need for JSON.

# It's all about the appcache

There are three cache types: [appliication,collection,member]
The cache types correlate nicly to [itemscope, itemetype, itemid]

You can scope a cache by [itemscope,itemtype,itemid]

```
  <html manifest='/application.appcache'>
    ...
  <html manifest='/pages/collection.appcache'>
    ...
  <html manifest='/pages/:id/member.appcache'>
    ...

```

Session storage is even tied to appcache. Manifests are cached with the current users last_updated time stamp 

```
 current_user.updated_at()
```

# Waxing poetic

In a lot of ways this framework is a standards based solution to the problem turbolinks was trying to address.

I love how DHH just wants his html css and javascript to do web stuff. I love rails. but my heart belongs to the web.

I want rails to do my server stuff, but this framework is fundamentally agnostic about where the html css and javascript  are coming from it's about what it does when it get's there.

we've started to loose the plot and it's time to remember  that the web is the only medium built for all of us, by all of us.

# Notes

we use server events to notify pages when their cache is stale. this way the framework has the option to be proactive about updating client caches. All he server events do is tell tell the user agent what resources have been updated

a collection cache can decide to include the page caches for the caches in it’s collection.

“/tips/trending.appcache”:
```
CACHE MANIFEST:
<%-for tip in Tip.trending-%>
 “/tips/#{Tip.id}”
 # “#{tip.updated_at}”
<%-end-%>
```

