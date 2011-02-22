ActionController::Routing::Routes.draw do |map|

  map.signin  "signin", :controller => "user_sessions", :action => "new"
  map.signout "signout", :controller => "user_sessions", :action => "destroy"

  match '/terms', :to => 'home#terms'
  match '/privacy', :to => 'home#privacy'
  match '/blog', :to => 'home#blog'
  match '/bookmarklet/agent', :to => 'home#agent'
  match '/bookmarklet/launcher.js', :to => 'home#weave'

  match '/signin', :to => 'user_sessions#new'
  match '/signout', :to => 'user_sessions#destroy'

  resources :user_sessions
  resources :tips
  resources :users
  
  root :to => 'home#index'
end