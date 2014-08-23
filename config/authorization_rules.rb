authorization do
  role :god do
    has_omnipotence
  end

  role :admin do
    includes :fan
    has_permission_on :users,       to: :manage
    has_permission_on :pages,       to: :manage
    has_permission_on :authors,     to: :manage
    has_permission_on :tips,        to: :manage
    has_permission_on :home,        to: :manage
    has_permission_on :admin,       to: [:test, :index]
  end

  role :fan do
    includes :guest
    has_permission_on :pages,       to: :read
    has_permission_on :authors,     to: :settings
    has_permission_on :users,       to: :settings
    has_permission_on :tips,        to: [:create,:received,:given]
    has_permission_on :sessions,    to: [
                                          :delete,
                                          :publish_actions,
                                          :manage_pages,
                                          :facebook_setup
                                        ]
    has_permission_on :tips,        to: [:update, :destroy] do
      if_attribute user: is { user }
    end

  end

  role :guest do
    has_permission_on :admin,       to: :ping
    has_permission_on :appcache,    to: :index
    has_permission_on :authors,     to: :enquire
    has_permission_on :application, to: [:appcache, :index]
    has_permission_on :sessions,    to: [:create, :failure]
    has_permission_on :tips,        to: [:new, :iframe]
    has_permission_on :pages,       to: [
                                         :read,
                                         :member_appcache,
                                         :collection_appcache,
                                         :trending,
                                         :recent
                                        ]
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :create, :includes => :new
  privilege :read,   :includes => [:index, :show]
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
