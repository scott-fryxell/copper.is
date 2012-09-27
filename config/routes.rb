require 'resque/server'
Copper::Application.routes.draw do
  resources :tips
  resources :orders
  resources :checks
  resources :identities

  resources :pages do
    resources :tips
  end
  resources :fans, :controller => "users", :as => :fans do 
    resources :tips
  end

  get    'cards', :to => 'cards#show',  :as => :show_card
  post   'cards', :to => 'cards#create',:as => :create_card
  put    'cards', :to => 'cards#update',:as => :update_card
  delete 'cards', :to => 'cards#delete', :as => :delete_card

  get 'authors/me', to:'authors#show'
  get 'authors/me/edit', to:'authors#edit'

  get 'about',   :to => 'home#about'
  get 'how',     :to => 'home#how'
  get 'contact', :to => 'home#contact'
  get 'terms',   :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'
  get 'faq',     :to => 'home#faq'
  get 'button',  :to => 'home#button'
  get 'states',  :to => 'home#states'
  get 'statistics',  :to => 'home#statistics'

  if Rails.env.test? || Rails.env.development?
    get 'test',    :to => 'home#test'
  end

  get 'embed_iframe.js', :to => 'home#iframe', :as => :iframe
  match "/auth/:provider/callback" => "sessions#create", :as => :provider_callback
  match '/auth/failure'  => 'sessions#failure'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin

  mount Resque::Server.new, :at => "/admin/resque"
  root :to => 'home#index'
end
