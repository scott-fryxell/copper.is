authorization do

  role :administrator do
  end

  role :developer do

  end

  role :publisher do
  end

  role :patron do
    has_permission_on [:tips], :to => [:index, :create, :edit, :update, :destroy, :new, :embed_iframe, :agent]
    has_permission_on [:sessions], :to => [:destroy]
    has_permission_on [:users], :to => [:new, :create, :edit, :update, :show, :pay, :tips]
  end

  role :guest do
    has_permission_on [:home], :to => [:all]
    has_permission_on [:tips], :to => [:embed_iframe]
  end

end