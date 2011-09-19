DirtyWhiteCouch::Application.routes.draw do

  get 'tips/agent', :to => 'tips#agent'
  get 'tips/embed_iframe.js', :to => 'tips#embed_iframe'

  get 'about', :to => 'home#about'
  get 'contact', :to => 'home#contact'
  get 'blog', :to => 'home#blog'
  get 'terms', :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'

  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout

  resources :tips
  resources :users

  root :to => 'home#index'
end
