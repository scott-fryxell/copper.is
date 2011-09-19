DirtyWhiteCouch::Application.routes.draw do

  resources :tips
  resources :users

  get 'blog', :to => 'home#blog'
  get 'bookmarklet/agent', :to => 'home#agent'
  get 'bookmarklet/embed_iframe.js', :to => 'home#embed_iframe'

  get 'terms', :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  root :to => 'home#index'
end
