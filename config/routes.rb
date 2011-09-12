DirtyWhiteCouch::Application.routes.draw do

  resources :tips
  resources :users
  resources :sessions

  get 'blog', :to => 'home#blog'
  get 'bookmarklet/agent', :to => 'home#agent'
  get 'bookmarklet/launcher.js', :to => 'home#weave'

  get 'terms', :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  root :to => 'home#index'
end
