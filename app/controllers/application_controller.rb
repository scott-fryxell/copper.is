require 'carmen'
include Carmen

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user, :item_scope, :user_url
  before_filter :set_current_user
  before_filter :set_default_cache_headers

  before_filter do
  end

  protected

  def set_default_cache_headers
    expires_in 1.minute, :public => true
  end


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

  #TODO: => "value",  this should be specfic to user or model agnostic
  def item_scope
    return nil unless current_user
    "itemscope itemtype=user itemid=/users/#{current_user.id}"
  end
end
