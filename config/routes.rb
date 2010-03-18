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

  map.root :tips

end