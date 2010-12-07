authorization do

  role :administrator do
    has_permission_on [:admin], :to => [:home]
    has_permission_on [:accounts, :addresses, :tips, :locators, :transactions], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:user_sessions], :to => [:destroy]
    has_permission_on [:users], :to => [:index, :edit, :update]
    has_permission_on [:admin_user_reports], :to => [:active]
  end

  role :developer do
  end

  role :publisher do
  end

  role :patron do
    has_permission_on [:tips, :transactions], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:user_sessions], :to => [:destroy, :create]
    has_permission_on [:users], :to => [:show, :new, :create, :edit, :update]
  end

  role :guest do
    has_permission_on [:user_sessions], :to => [:create]
  end

end