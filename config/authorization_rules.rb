 authorization do

  role :admin do
    includes :patron
    has_permission_on :rails_admin_history, :to => [:list, :slider, :for_model, :for_object, :history_show]
    has_permission_on :rails_admin_main, :to => [:index, :show, :new, :edit, :create, :update, :destroy, :list, :delete, :bulk_delete, :bulk_destroy, :get_pages, :history_show, :history_index, :dashboard, :show_in_app]
  end

  role :patron do
    includes :guest
    has_permission_on [:sessions], :to => [:destroy]

    has_permission_on [:users], :to => [:new, :create, :edit, :update, :show, :pay, :identities, :author, :badge] do
      has_permission_on [:tips], :to => [:index, :create, :edit, :update, :destroy, :new, :embed_iframe, :agent]
      has_permission_on [:checks], :to => [:index]
      has_permission_on [:identities], :to => [:index, :destroy]
    end
  end

  role :guest do
    has_permission_on [:home], :to => [:all]
    has_permission_on [:tips], :to => [:embed_iframe]
    has_permission_on [:identities], :to => [:show, :wanted]
  end

end
