authorization do

  role :admin do
    includes :fan
    has_permission_on :rails_admin_history, :to => [:list, :slider, :for_model, :for_object, :history_show]
    has_permission_on :rails_admin_main, :to => [:index, :show, :new, :edit, :create, :update, :destroy, :list, :delete, :bulk_delete, :bulk_destroy, :get_pages, :history_show, :history_index, :dashboard, :show_in_app]
    has_permission_on :authorization_rules, :to => :read
    has_permission_on :authorization_usages, :to => :read
  end

  role :fan do
    includes :guest
    has_permission_on :sessions,   :to => :delete
    has_permission_on :users,      :to => [:show,:update] do
      if_attribute :id => is { user.id }
    end
    has_permission_on :tips,       :to => [:create]
    has_permission_on :tips,       :to => [:update, :destroy] do
      if_attribute :user => is { user }
    end

    has_permission_on :checks,     :to => [:read]
    has_permission_on :orders,     :to => [:read,:update]
    has_permission_on :identities, :to => [:edit]
    has_permission_on :pages,      :to => [:read]
    has_permission_on :cards,      :to => [:manage]
  end

  role :guest do
    has_permission_on :tips,       :to => [:read]
    has_permission_on :pages,      :to => [:read]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :create, :includes => :new
  privilege :read,   :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
