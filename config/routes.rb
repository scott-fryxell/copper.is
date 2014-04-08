require 'resque/server'
Copper::Application.routes.draw do

  resources :tips, except:[:edit, :show]

  get "admin",                            to:'home#admin',   :as => :admin
  get 'ping',                             to:'home#ping',   :as => :ping
  get 'embed_iframe.js',                  to:'home#iframe', :as => :iframe
  get 'test',                             to:'home#test' unless Rails.env.production?
  post 'claim_facebook_pages',            to:'home#claim_facebook_pages'

  match "signout",                        to:"sessions#destroy", :as => :signout
  match "signin",                         to:"sessions#new",     :as => :signin
  match "/auth/:provider/callback",       to:"sessions#create",  :as => :provider_callback
  match '/auth/failure',                  to:'sessions#failure'
  match '/auth/facebook/setup',           to:'sessions#facebook_setup'
  match '/auth/facebook/publish_actions', to:'sessions#publish_actions'
  match '/auth/facebook/manage_pages',    to:'sessions#manage_pages'
  root                                    to:'home#index'

  mount Resque::Server.new, :at => "/admin/resque"

  # constraints allow usernames to have periods
  # get "/:provider/:username",  to:'authors#enquire', constraints:{username:/[^\/]+/}

end
