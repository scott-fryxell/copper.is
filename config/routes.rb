ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'home' do |home|
    home.terms      "terms",      :action => "terms"
    home.privacy    "privacy",    :action => "privacy"
  end

  map.signin  "signin", :controller => "user_sessions", :action => "new"
  map.signout "signout", :controller => "user_sessions", :action => "destroy"

  map.blog       "blog",                    :controller => "home", :action => "blog"
  map.agent      "bookmarklet/agent",       :controller => "home", :action => "agent"
  map.weave      "bookmarklet/launcher.js", :controller => "home", :action => "weave"
  map.signin     "signin",                  :controller => "user_sessions", :action => "new"
  map.signout    "signout",                 :controller => "user_sessions", :action => "destroy"

  map.resources :user_sessions
  map.resources :tips
  map.resources :users
  
  map.root :controller => "home", :action => "index"

end