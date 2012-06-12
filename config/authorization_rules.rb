authorization do

  role :admin do
    includes :patron
    has_permission_on :rails_admin_history, :to => [:list, :slider, :for_model, :for_object, :history_show]
    has_permission_on :rails_admin_main, :to => [:index, :show, :new, :edit, :create, :update, :destroy, :list, :delete, :bulk_delete, :bulk_destroy, :get_pages, :history_show, :history_index, :dashboard, :show_in_app]
  end

  role :patron do
    includes :guest
    has_permission_on :sessions,   :to => :delete

    has_permission_on :users,      :to => [:read,:update]
    has_permission_on :tips,       :to => [:manage]
    has_permission_on :checks,     :to => [:read]
    has_permission_on :orders,     :to => [:read,:update]
    has_permission_on :identities, :to => [:manage]
    has_permission_on :pages,      :to => [:read]
    has_permission_on :cards,      :to => [:manage]
  end

  role :guest do
    has_permission_on :tips,       :to => [:read]
    has_permission_on :identities, :to => [:create]
    has_permission_on :pages,      :to => [:read]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read,   :includes => [:index, :show]
  privilege :build,  :includes => [:new,:create]
  privilege :update, :includes => [:edit,:update]
  privilege :delete, :includes => :destroy
end
