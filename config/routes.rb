require 'resque/server'

Copper::Application.routes.draw do
  resources :tips
  
  resources :orders
  resources :checks
  
  resources :pages do
    resources :tips
  end
  
  resources :identities
  
  resources :users do
    resources :tips
  end

  # get 'tips/agent', :to => 'tips#agent', :as => :agent
  get 'tips/embed_iframe.js', :to => 'tips#embed_iframe', :as => :iframe

  get 'about', :to => 'home#about'
  get 'how', :to => 'home#how'
  get 'contact', :to => 'home#contact'
  get 'terms', :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'
  get 'faq', :to => 'home#faq'
  get 'button', :to => 'home#button'
  get 'buckingthesystem', :to => 'home#index'

  match "/auth/:provider/callback" => "sessions#create"
  match '/auth/failure' => 'sessions#failure'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin
  
  mount Resque::Server.new, :at => "/resque"
  
  root :to => 'home#index'
end
