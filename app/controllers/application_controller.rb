require 'carmen'
include Carmen

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user, :item_scope, :user_url
  before_filter :set_current_user

  before_filter do
    Honeybadger.context({
      :user_id => current_user.id,
      :user_email => current_user.email
    }) if current_user
  end

  protected

  def user_url(user)
    if  current_user.id == user.id
      return 'me'
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

  def item_scope
    return nil unless current_user
    "itemscope itemtype=users itemid=/users/#{current_user.id}"
  end
end
