authorization do

  role :admin do
  end

  role :patron do
    has_permission_on [:sessions], :to => [:destroy]

    has_permission_on [:users], :to => [:new, :create, :edit, :update, :show, :pay, :identities, :author] do
      has_permission_on [:tips], :to => [:index, :create, :edit, :update, :destroy, :new, :embed_iframe, :agent]
      has_permission_on [:royalty_orders], :to => [:index]
      has_permission_on [:identities], :to => [:index, :destroy]
    end
  end

  role :guest do
    has_permission_on [:home], :to => [:all]
    has_permission_on [:tips], :to => [:embed_iframe]
    has_permission_on [:identities], :to => [:show]
  end

end
