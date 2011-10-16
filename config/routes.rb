DirtyWhiteCouch::Application.routes.draw do

  get 'tips/agent', :to => 'tips#agent', :as => :agent
  get 'tips/embed_iframe.js', :to => 'tips#embed_iframe'

  get 'about', :to => 'home#about'
  get 'contact', :to => 'home#contact'
  get 'blog', :to => 'home#blog'
  get 'terms', :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'
  get 'authors', :to => 'home#authors'
  get 'button', :to => 'home#button'
  match "/auth/:provider/callback" => "sessions#create"
  match '/auth/failure' => 'sessions#failure'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin
  match "/DirtyWhiteCouch.com.safariextz", :to => "home#safari"
  resources :tips
  resources :users
  root :to => 'home#index'
end
