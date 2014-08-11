require 'resque/server'
Copper::Application.routes.draw do

  resources :tips, only:[:create, :update, :show, :new, :destroy] do
    collection do
      get  'embed_iframe.js',            to:'tips#iframe', as: :iframe
    end
  end

  resources :authors, only:[:show] do
    member do
      post 'claim_facebook_pages'
      post 'authorize_facebook_privelege'
      post 'can_post_to_facebook'
      post 'can_view_facebook_pages'
    end

  end

  resources :pages, only:[:show, :update] do
    member do
      get "appcache",                    to:"pages#member_appcache"
    end

    collection do
      get "appcache",                    to:"pages#collection_appcache"
      get "trending"
      get "recent"
    end
  end



  get  '/admin',                          to:'admin#index'
  get  '/ping',                           to:'admin#ping'
  get  '/test',                           to:'admin#test'   unless Rails.env.production?


  get  '/signout',                       to:'sessions#destroy', as: :signout
  get  '/auth/:provider/callback',       to:'sessions#create'
  post '/auth/failure',                  to:'sessions#failure'

  get "/appcache",                       to:"application#appcache"
  root                                   to:'application#index'

  mount Resque::Server.new,              at:'/admin/resque'

  # constraints allow usernames to have periods
  # get '/:provider/:username',  to:'authors#enquire', constraints:{username:/[^\/]+/}

end
