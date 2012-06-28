class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user, :item_scope
  before_filter :set_current_user
  before_filter :session_expiry, :except => [:signin, :signout, :provider_callback]
  before_filter :update_activity_time, :except => [:signout, :signout, :provider_callback]

  protected

  def session_expiry
    expire_time = session[:expires_at] || Time.now
    @session_time_left = (expire_time - Time.now).to_i
    unless @session_time_left > 0
      reset_session
    end
  end

  def update_activity_time
    session[:expires_at] = 90.days.from_now
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

  def item_scope
    type = params[:controller].parameterize
    id = params['id']
    if id
      item_id= "itemid='/#{type}/#{id}'"
    end
    "itemscoped itemtype='#{type}' #{item_id}"
  end

end
