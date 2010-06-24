authorization do
  role :admin do
  end
  
  role :developer do
  end
  
  role :publisher do
  end
  
  role :patron do
    has_permission_on [:addresses, :tips, :accounts, :resources, :orders, :transactions], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
    has_permission_on [:user_sessions], :to => [:destroy]
    has_permission_on [:users], :to => [:edit, :update]
  end
  
  role :guest do
    has_permission_on [:reports, :resources], :to => [:index, :show]
    has_permission_on [:user_sessions], :to => [:new, :create]

  end
end