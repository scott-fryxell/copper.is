ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'home' do |home|
    home.terms      "terms",      :action => "terms"
    home.privacy    "privacy",    :action => "privacy"
    home.contact    "contact",    :action => "contact"
    home.subscribe  "subscribe",  :action => "subscribe"
    home.about      "about",      :action => "about"
  end

  map.with_options  :controller => 'home' do |bookmarklet|
    bookmarklet.weave  "bookmarklet/weave.js",  :action => "weave"
    bookmarklet.weave  "bookmarklet/agent",  :action => "agent"
  end

  map.signin "signin", :controller => "user_sessions", :action => "new"
  map.signout "signout", :controller => "user_sessions", :action => "destroy"


  map.signin "signin", :controller => "user_sessions", :action => "new"
  map.signout "signout", :controller => "user_sessions", :action => "destroy"
  map.addrpxauth "addrpxauth", :controller => "users", :action => "addrpxauth", :method => :post


  map.resources :user_sessions
  map.resources :tips
  map.resources :users
  map.resources :locators

  map.root :controller => "home", :action => "index"

end