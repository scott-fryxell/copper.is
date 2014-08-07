authorization do
  role :god do
    has_omnipotence
  end

  role :admin do
    includes :fan
    has_permission_on :users,   :to => :manage
    has_permission_on :pages,   :to => :manage
    has_permission_on :authors, :to => :manage
    has_permission_on :tips,    :to => :manage
    has_permission_on :home,    :to => :manage
    has_permission_on :admin,   :to => :manage
  end

  role :fan do
    includes :guest
    has_permission_on :sessions,   :to => :delete
    has_permission_on :pages,      :to => :read
    has_permission_on :tips,       :to => [:create]
    has_permission_on :tips,       :to => [:update, :destroy] do
      if_attribute :user => is { user }
    end

  end

  role :guest do
    has_permission_on :pages,       :to => [:read,
                                            :application_appcache,
                                            :member_appcache,
                                            :collection_cache,
                                            :trending,
                                            :recent
                                           ]
    has_permission_on :tips,        :to => [:new, :iframe]
    has_permission_on :authors,     :to => [:enquire]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :create, :includes => :new
  privilege :read,   :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
