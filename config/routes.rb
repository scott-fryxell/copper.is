require 'resque/server'
Copper::Application.routes.draw do
  resources :tips
  resources :orders
  resources :checks
  resources :identities

  resources :pages do
    resources :tips
  end
  resources :users do
    resources :tips
  end
  get    'cards', :to => 'cards#show',  :as => :show_card
  post   'cards', :to => 'cards#create',:as => :create_card
  put    'cards', :to => 'cards#update',:as => :update_card
  delete 'cards', :to => 'cards#delete',:as => :delete_card

  get 'about', :to => 'home#about'
  get 'how', :to => 'home#how'
  get 'contact', :to => 'home#contact'
  get 'terms', :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'
  get 'faq', :to => 'home#faq'
  get 'button', :to => 'home#button'
  get 'buckingthesystem', :to => 'home#index'
  get 'badge', :to => 'home#badge', :as => :badge
  get 'embed_iframe.js', :to => 'home#iframe', :as => :iframe

  match "/auth/:provider/callback" => "sessions#create"
  match '/auth/failure' => 'sessions#failure'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin

  mount Resque::Server.new, :at => "/resque"
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root :to => 'home#index'
end
