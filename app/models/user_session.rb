class UserSession < Authlogic::Session::Base
  remember_me_for 14.days
end