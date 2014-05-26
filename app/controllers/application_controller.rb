class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user, :user_url, :layout
  before_action :set_current_user
  before_action :set_default_cache_headers

  protected

  def set_default_cache_headers
    expires_in 1.minute, :public => true
  end


  def user_url(user)
    if  current_user.id == user.id
      return '/me'
    else
      return "/users/#{user.id}"
    end
  end

  def set_current_user
    Authorization.current_user = current_user
  end

  def permission_denied
    if current_user
      render nothing:true, status:403
    else
      render nothing:true, status:401
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
