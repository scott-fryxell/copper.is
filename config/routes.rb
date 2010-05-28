ActionController::Routing::Routes.draw do |map|

  map.resources :accounts

  map.resources :addresses

  map.resources :resources

  map.resources :urls

  map.resources :tips

  map.resources :orders

  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.resources :user_sessions

  map.resources :users

  map.index "terms/", :controller => "home", :action => "terms"
  map.index "privacy/", :controller => "home", :action => "privacy"
  map.index "contact/", :controller => "home", :action => "contact"
  map.index "subscribe/", :controller => "home", :action => "subscribe"  
  map.root :controller => "home", :action => "index"

  map.mailtest "mailtest", :controller => "mail_test", :action => "create_confirmation"
end