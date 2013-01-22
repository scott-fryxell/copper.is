authorization do

  role :admin do
    has_omnipotence
  end

  role :fan do
    includes :guest
    has_permission_on :sessions,   :to => :delete
    has_permission_on :users,       :to => [:show,:update] do
      if_attribute :id => is { user.id }
    end
    
    has_permission_on :tips,       :to => [:update, :destroy, :create] do
      if_attribute :user => is { user }
    end
    has_permission_on :home,       :to => [:read]
    has_permission_on :authors,    :to => [:edit, :destroy]
    has_permission_on :cards,      :to => [:manage]
  end

  role :guest do
    has_permission_on :pages,       :to => [:show]
    has_permission_on :tips,       :to => [:new]
    has_permission_on :authors,    :to => [:edit] do
      if_attribute :identity_state => 'wanted'
    end
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :create, :includes => :new
  privilege :read,   :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
