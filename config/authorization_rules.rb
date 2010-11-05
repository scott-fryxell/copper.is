authorization do

  role :administrator do
    has_permission_on [:admin], :to => [:home]
    has_permission_on [:accounts, :addresses, :tips, :locators, :transactions], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:user_sessions], :to => [:destroy]
    has_permission_on [:users], :to => [:edit, :update]
    has_permission_on [:admin_user_reports], :to => [:active]
  end

  role :developer do
  end

  role :publisher do
  end

  role :patron do
    has_permission_on [:accounts, :addresses, :tips, :locators, :transactions], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:orders], :to => [:index, :show, :new, :create, :prepare, :change]
    has_permission_on [:user_sessions], :to => [:destroy]
    has_permission_on [:users], :to => [:edit, :update_password, :update_user, :confirm_new_email]
    has_permission_on [:sites, :pages], :to => [:index, :show, :new, :create]

  end

  role :guest do
    has_permission_on [:reports, :locators], :to => [:index, :show]
    has_permission_on [:user_sessions], :to => [:new, :create]
  end

end