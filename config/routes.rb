require 'resque/server'
Copper::Application.routes.draw do


  concern :apppcachable do
    collection do
      get 'appcache',                    to:'pages#collection_appcache'
    end

    member do
      get 'appcache',                    to:'pages#member_appcache'
    end

  end

  resources :users, only:[:update, :show]
  resources :authors, only:[:show]

  resources :tips, only:[:create, :update, :show, :new, :destroy] do
    collection do
      get  'embed_iframe.js',            to:'tips#iframe', as: :iframe
      get  'given'
      get  'received'
    end
  end

  resources :pages, only:[:show, :update] do
    member do
      get 'appcache',                    to:'pages#member_appcache'
    end

    collection do
      get 'appcache',                    to:'pages#collection_appcache'
      get 'trending'
      get 'recent'
    end
  end


  get  '/settings',                      to:'users#settings'
  get  '/authorizations',                to:'authors#settings'

  get  '/ping',                          to:'admin#ping'
  get  '/test',                          to:'admin#test' unless Rails.env.production?

  get  '/signout',                       to:'sessions#destroy', as: :signout
  get  '/auth/:provider/callback',       to:'sessions#create'
  get  '/auth/failure',                  to:'sessions#failure'

  get  '/appcache',                       to:'application#appcache'
  get  '/events',                         to:'events#publisher'

  root                                   to:'application#index'

  mount Resque::Server.new,              at:'/admin/resque'

  # constraints allow usernames to have periods
  get '/:provider/:username',  to:'authors#enquire', constraints:{username:/[^\/]+/}

end
