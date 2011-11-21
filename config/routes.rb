DirtyWhiteCouch::Application.routes.draw do

  resources :users do
    post 'pay', :on => :member
    resources :tips
  end

  get 'tips/agent', :to => 'tips#agent', :as => :agent
  get 'tips/embed_iframe.js', :to => 'tips#embed_iframe', :as => :iframe

  get 'about', :to => 'home#about'
  get 'contact', :to => 'home#contact'
  get 'blog', :to => 'home#blog'
  get 'terms', :to => 'home#terms'
  get 'privacy', :to => 'home#privacy'
  get 'authors', :to => 'home#authors'
  get 'button', :to => 'home#button'
  get "/DirtyWhiteCouch.com.safariextz", :to => "home#safari"

  match "/auth/:provider/callback" => "sessions#create"
  match '/auth/failure' => 'sessions#failure'
  match "/signout" => "sessions#destroy", :as => :signout
  match "/signin" => "sessions#new", :as => :signin

  root :to => 'home#index'
end
