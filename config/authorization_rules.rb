 authorization do

  role :admin do
    includes :patron
  end

  role :patron do
    includes :guest
    has_permission_on [:sessions], :to => [:destroy]

    has_permission_on [:users], :to => [:index,:new, :create, :edit, :update, :show, :pay, :identities, :author, :badge] do
      has_permission_on [:tips], :to => [:show,:index, :create, :edit, :update, :destroy, :new, :embed_iframe, :agent]
      has_permission_on [:checks], :to => [:new, :index, :destroy, :update, :edit, :show, :create]
      has_permission_on [:identities], :to => [:index, :destroy]
    end
  end

  role :guest do
    has_permission_on [:home], :to => [:all]
    has_permission_on [:tips], :to => [:show,:index,:embed_iframe]
    has_permission_on [:identities], :to => [:show, :wanted]
  end

end
