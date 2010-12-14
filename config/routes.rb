ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'home' do |home|
    home.terms      "terms",      :action => "terms"
    home.privacy    "privacy",    :action => "privacy"
  end


  map.signin  "signin", :controller => "user_sessions", :action => "new"
  map.signout "signout", :controller => "user_sessions", :action => "destroy"


  map.blog       "blog", :controller => "home", :action => "blog"
  map.agent      "bookmarklet/agent", :controller => "home", :action => "agent"
  map.weave      "bookmarklet/weave.js", :controller => "home", :action => "weave"
  map.signin     "signin", :controller => "user_sessions", :action => "new"
  map.signout    "signout", :controller => "user_sessions", :action => "destroy"
  map.addrpxauth "addrpxauth", :controller => "users", :action => "addrpxauth", :method => :post


  map.resources :user_sessions
  map.resources :tips
  map.resources :users
  map.resources :locators

  map.root :controller => "home", :action => "index"

end