require 'resque/server'
Copper::Application.routes.draw do
  resources :tips, except:[:edit]
  resources :checks, only:[:index, :show]

  resources :orders, only:[:index, :show] do
    resources :tips, only:[:index]
  end

  resources :authors, only:[:index, :show, :update, :destroy] do
    resources :pages, only:[:index]
  end

  resources :pages, only:[:index, :show, :update] do
    resources :tips, only:[:index]
    member do
       put 'reject'
     end
  end

  resources :users, only:[:index, :update, :show] do
    resources :tips, only:[:index]
    resources :authors, only:[:index]
    resources :pages, only:[:index]
    resources :orders, only:[:index]
    resources :checks, only:[:index]
  end

  get    'cards', to:'cards#show',   :as => :show_card
  post   'cards', to:'cards#create', :as => :create_card
  put    'cards', to:'cards#update', :as => :update_card
  delete 'cards', to:'cards#delete', :as => :delete_card

  get 'tip_some_pages',       to:'home#tip_some_pages'
  get "integrations",         to:'home#integrations'
  get 'badge',                to:'home#badge'
  get 'author',               to:'home#author'
  get 'settings',             to:'home#settings'
  get 'about',                to:'home#about'
  get 'getting_started',      to:'home#getting_started'
  get 'tipped',               to:'home#tipped'
  get 'contact',              to:'home#contact'
  get 'terms',                to:'home#terms'
  get 'privacy',              to:'home#privacy'
  get 'faq',                  to:'home#faq'
  get 'states',               to:'home#states'
  get 'ping',                 to:'home#ping'
  get 'embed_iframe.js',      to:'home#iframe', :as => :iframe

  post '/claim_facebook_pages',      to:'home#claim_facebook_pages'

  if Rails.env.test? || Rails.env.development? || Rails.env.staging?
    get 'test',    to:'home#test'
  end

  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin
  match "/auth/:provider/callback" => "sessions#create", :as => :provider_callback
  match '/auth/failure'  => 'sessions#failure'
  match '/auth/facebook/setup', :to => 'sessions#facebook_setup'
  match '/auth/facebook/publish_actions', :to => 'sessions#publish_actions'
  match '/auth/facebook/manage_pages', :to => 'sessions#manage_pages'

  mount Resque::Server.new, :at => "/admin/resque"
  root :to => 'home#index'

  # constraints allow usernames to have periods
  get "/:provider/:username",  to:'authors#enquire', constraints:{username:/[^\/]+/}

end
