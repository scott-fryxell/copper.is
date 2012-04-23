require 'resque/server'

Copper::Application.routes.draw do
  resources :users do
    resources :tips
    resources :royalty_orders do
      resources :royalties
    end
    resources :identities
    post 'pay', :on => :member
    get 'author', :to => 'users#author', :as => :author
    get 'badge', :to => 'users#badge', :as => :badge
  end
  
  # resources :tips
  # resources :tip_orders do
  #   resources :tips
  # end
  # resources :royalty_checks do
  #   resources :tips
  # end
  # resources :pages
  # resources :identities
  # resources :users
  
  get 'tips/agent', :to => 'tips#agent', :as => :agent
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
