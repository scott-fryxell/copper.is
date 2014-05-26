require 'resque/server'
Copper::Application.routes.draw do

  resources :tips, except:[:edit, :show]

  get  'admin',                          to:'admin#index', :as => :admin
  get  'ping',                           to:'admin#ping',  :as => :ping
  get  'test',                           to:'admin#test'   unless Rails.env.production?

  get  'embed_iframe.js',                to:'tips#iframe', :as => :iframe

  post 'claim_facebook_pages',           to:'users#claim_facebook_pages'

  get  '/signout',                       to:'sessions#destroy', :as => :signout
  get  '/signin',                        to:'sessions#new',     :as => :signin
  post '/auth/:provider/callback',       to:'sessions#create',  :as => :provider_callback
  post '/auth/failure',                  to:'sessions#failure'
  post '/auth/facebook/setup',           to:'sessions#facebook_setup'
  post '/auth/facebook/publish_actions', to:'sessions#publish_actions'
  post '/auth/facebook/manage_pages',    to:'sessions#manage_pages'

  get  'pages.appcache',                 to:'pages#appcache'
  root                                   to:'pages#index'

  mount Resque::Server.new, :at => '/admin/resque'

  # constraints allow usernames to have periods
  # get '/:provider/:username',  to:'authors#enquire', constraints:{username:/[^\/]+/}

end
