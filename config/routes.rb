DirtyWhiteCouch::Application.routes.draw do

  resources :tips
  resources :users
  resources :user_sessions


  get 'blog', :to => 'home#blog'
  get 'bookmarklet/agent', :to => 'home#agent'
  get 'bookmarklet/launcher.js', :to => 'home#weave'
  match 'signin', :to => 'user_sessions#new'
  match 'signout', :to => 'user_sessions#destroy'


  root :to => 'home#index'
end
