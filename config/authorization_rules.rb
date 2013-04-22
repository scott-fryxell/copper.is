authorization do

  role :admin do
    # has_omnipotence
    includes :fan
    has_permission_on :users,   :to => :manage
    has_permission_on :authors, :to => :manage
    has_permission_on :tips,    :to => :manage
    has_permission_on :admin,   :to => :read
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
    has_permission_on :authors,    :to => [:edit, :destroy]
    # has_permission_on :pages,      :to => [:index]
    has_permission_on :cards,      :to => [:manage]
  end

  role :guest do
    has_permission_on :pages,       :to => [:show]
    has_permission_on :tips,       :to => [:read, :new]
    has_permission_on :authors,    :to => [:edit] do
      if_attribute :identity_state => 'wanted'
    end
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