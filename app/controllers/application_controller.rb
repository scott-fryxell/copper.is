require 'carmen'
include Carmen

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user, :item_scope
  before_filter :set_current_user

  protected

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
    return nil unless current_user
    "itemscope itemtype=users itemid=#{current_user.id}"
  end
end
