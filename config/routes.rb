ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'home' do |home|
    home.terms     "terms",     :action => "terms"
    home.privacy   "privacy",   :action => "privacy"
    home.contact   "contact",   :action => "contact"
    home.feed      "subscribe", :action => "subscribe"
  end

  map.with_options  :controller => 'reports' do |report|
    report.page_report        "pages",      :action => "pages"
    report.publisher_report   "publishers", :action => "publishers"
  end

  map.with_options :controller => 'user_sessions' do |session|
    session.login         "login",          :action => "new"
    session.authenticate  "authenticate",   :action => "create"
    session.logout        "logout",         :action => "destroy"
  end

  map.with_options  :controller => 'password_resets' do |password|
    password.password_reset_new       "password/reset/request", :action => "new"
    password.password_reset_create    "password/reset/submit",  :action => "create"
    password.password_reset_edit      "password/reset/:id",     :action => "edit"
    password.password_reset_update    "password/reset/:id/update",    :action => "update"
  end

  map.with_options :controller => 'user_activations' do |activations|
    activations.activate          "activate/:id",               :action => "activate"
    activations.new_activation    "activate",                   :action => "new"
    activations.send_activation   "account/activate/request",   :action => "send_activation"
  end

  # RESTful API
  map.resources :tips
  map.resources :users
  map.resources :resources

  # Home
  map.root :controller => "home", :action => "index"

  # Tests
  map.mailtest "mailtest", :controller => "mail_test", :action => "create_confirmation"
end