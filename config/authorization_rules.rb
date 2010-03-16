authorization do
  
  role :admin do
  end
  
  role :developer do
  end
  
  role :publisher do
  end
  
  role :patron do
    has_permission_on [:tips, :resources, :orders, :transactions], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :guest do
    has_permission_on [:tips, :resources], :to => [:index, :show]
  end
  
end