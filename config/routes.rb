ActionController::Routing::Routes.draw do |map|
  map.with_options :controller => 'home' do |home|
    home.terms      "terms",      :action => "terms"
    home.privacy    "privacy",    :action => "privacy"
    home.contact    "contact",    :action => "contact"
    home.subscribe  "subscribe",  :action => "subscribe"
    home.about     "about",     :action => "about"
  end

  map.with_options  :controller => 'support' do |support|
    support.support               "support",                      :action => "home"
    support.compromised_account   "support/compromised_account",  :action => "compromised_account"
  end

  map.with_options  :controller => 'bookmarklet' do |bookmarklet|
    bookmarklet.instructions  "bookmarklet",    :action => "instructions"
    bookmarklet.weave  "bookmarklet/weave.js",  :action => "weave"
  end


  map.with_options  :controller => 'reports' do |report|
    report.pages_report    "report/pages",   :action => "pages"
    report.sites_report    "report/sites",   :action => "sites"
  end

  map.with_options :controller => 'user_sessions' do |session|
    session.login         "login",          :action => "new"
    session.authenticate  "authenticate",   :action => "create"
    session.logout        "logout",         :action => "destroy"
  end

  map.with_options  :controller => 'password_resets' do |password|
    password.password_reset_new       "password/reset/request",     :action => "new"
    password.password_reset_create    "password/reset/submit",      :action => "create"
    password.password_reset_edit      "password/reset/:id",         :action => "edit"
    password.password_reset_update    "password/reset/:id/update",  :action => "update"
  end

  map.with_options :controller => 'user_activations' do |activations|
    activations.activate          "activate/:id",               :action => "activate"
    activations.new_activation    "activate",                   :action => "new"
    activations.send_activation   "account/activate/request",   :action => "send_activation"
  end

  map.with_options :controller => 'admin' do |admin|
    admin.admin      "admin",      :action => "home"
  end

  map.with_options :controller => 'admin_user_reports' do |reports|
    reports.active_users      "admin/reports/users/active",    :action => "active"
  end

  map.with_options :controller => 'orders' do |order|
    order.order_prepare   "order/prepare",    :action => "prepare"
  end

  map.with_options :controller => 'users' do |user|
    user.update_user   "users/update_user",           :action => "update_user"
    user.update_password   "users/update_password",   :action => "update_password"
    user.confirm_new_email  "confirm_new_email/:id",  :action => "confirm_new_email"
  end


  # RESTful API
  map.resources :tips
  map.resources :users
  map.resources :locators
  map.resources :orders

  # Home
  map.root :controller => "home", :action => "index"

  # Tests
  map.mailtest "mailtest", :controller => "mail_test", :action => "create_confirmation"
end