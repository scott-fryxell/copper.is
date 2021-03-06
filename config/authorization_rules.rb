authorization do
  role :god do
    has_omnipotence
  end

  role :admin do
    includes :fan
    has_permission_on :users,    :to => :manage
    has_permission_on :pages,   :to => :manage
    has_permission_on :authors, :to => :manage
    has_permission_on :tips,      :to => :manage
    has_permission_on :home,    :to => :manage
  end

  role :fan do
    includes :guest
    has_permission_on :sessions,   :to => :delete
    has_permission_on :home,       :to => [:read]
    has_permission_on :users,       :to => [:show,:update] do
      if_attribute :id => is { user.id }
    end

    has_permission_on :tips,       :to => [:create]
    has_permission_on :tips,       :to => [:update, :destroy] do
      if_attribute :user => is { user }
    end

    has_permission_on :checks,     :to => [:read]
    has_permission_on :orders,     :to => [:read,:update]
    has_permission_on :authors,    :to => [:edit, :destroy] do
      if_attribute :user => is { user }
    end
    has_permission_on :cards,       :to => [:manage]
  end

  role :guest do
    has_permission_on :pages,       :to => [:show]
    has_permission_on :tips,          :to => [:new]
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