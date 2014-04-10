require 'resque/server'
Copper::Application.routes.draw do

  resources :tips, except:[:edit, :show]

  get "admin",                            to:'admin#index',   :as => :admin
  get 'ping',                             to:'admin#ping',   :as => :ping
  get 'embed_iframe.js',                  to:'tips#iframe', :as => :iframe
  get 'test',                             to:'admin#test' unless Rails.env.production?
  post 'claim_facebook_pages',            to:'users#claim_facebook_pages'

  match "signout",                        to:"sessions#destroy", :as => :signout
  match "signin",                         to:"sessions#new",     :as => :signin
  match "/auth/:provider/callback",       to:"sessions#create",  :as => :provider_callback
  match '/auth/failure',                  to:'sessions#failure'
  match '/auth/facebook/setup',           to:'sessions#facebook_setup'
  match '/auth/facebook/publish_actions', to:'sessions#publish_actions'
  match '/auth/facebook/manage_pages',    to:'sessions#manage_pages'
  root                                    to:'pages#index'

  mount Resque::Server.new, :at => "/admin/resque"

  # constraints allow usernames to have periods
  # get "/:provider/:username",  to:'authors#enquire', constraints:{username:/[^\/]+/}

end
