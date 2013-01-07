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

  get    'cards', to:'cards#show',  :as => :show_card
  post   'cards', to:'cards#create',:as => :create_card
  put    'cards', to:'cards#update',:as => :update_card
  delete 'cards', to:'cards#delete', :as => :delete_card

  get 'author',          to:'home#author' 
  get 'settings',        to:'home#settings'
  get 'about',           to:'home#about'
  get 'welcome',         to:'home#welcome'
  get 'contact',         to:'home#contact'
  get 'terms',           to:'home#terms'
  get 'privacy',         to:'home#privacy'
  get 'faq',             to:'home#faq'
  get 'button',          to:'home#button'
  get 'states',          to:'home#states'
  get 'statistics',      to:'home#statistics'
  get 'embed_iframe.js', to:'home#iframe', :as => :iframe

  if Rails.env.test? || Rails.env.development?
    get 'test',    to:'home#test'
  end

  match "/auth/:provider/callback" => "sessions#create", :as => :provider_callback
  match '/auth/failure'  => 'sessions#failure'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin

  mount Resque::Server.new, :at => "/admin/resque"
  root :to => 'home#index'
end
