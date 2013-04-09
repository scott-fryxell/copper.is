require 'resque/server'
Copper::Application.routes.draw do
  resources :tips
  resources :orders
  resources :checks
  resources :authors
  resources :pages
  resources :users

  get    'cards', to:'cards#show',  :as => :show_card
  post   'cards', to:'cards#create',:as => :create_card
  put    'cards', to:'cards#update',:as => :update_card
  delete 'cards', to:'cards#delete', :as => :delete_card

  get 'tip_some_pages', to:'home#tip_some_pages'
  get "admin",           to:'admin#index'
  get 'badge',           to:'home#badge' 
  get 'author',          to:'home#author' 
  get 'settings',        to:'home#settings'
  get 'about',           to:'home#about'
  get 'welcome',         to:'home#welcome'
  get 'contact',         to:'home#contact'
  get 'terms',           to:'home#terms'
  get 'privacy',         to:'home#privacy'
  get 'faq',             to:'home#faq'
  get 'states',          to:'home#states'
  get 'statistics',      to:'home#statistics'
  get 'getting_started', to:'home#getting_started'
  get 'embed_iframe.js', to:'home#iframe', :as => :iframe
  post '/claim_facebook_pages',      to:'home#claim_facebook_pages'

  if Rails.env.test? || Rails.env.development? || Rails.env.staging?
    get 'test',    to:'home#test'
  end

  match "/auth/:provider/callback" => "sessions#create", :as => :provider_callback
  match '/auth/failure'  => 'sessions#failure'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin

  match '/auth/facebook/setup', :to => 'sessions#facebook_setup'
  match '/auth/facebook/publish_actions', :to => 'sessions#publish_actions'
  match '/auth/facebook/manage_pages', :to => 'sessions#manage_pages'
  
  mount Resque::Server.new, :at => "/admin/resque"
  root :to => 'home#index'
end