authorization do
  
  role :admin do
    includes :patron
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
