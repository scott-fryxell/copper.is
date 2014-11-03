class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  respond_to :html
  filter_access_to :all
  protect_from_forgery

  helper_method :current_user, :user_url,         :page_scope,
                :cache_url,    :cents_to_dollars, :icons,
                :bust_cache

  before_action :set_current_user

  def appcache
    render action:'appcache', layout:false, content_type:'text/cache-manifest'
  end

  def index
    # home page
  end

protected

  def icons
    Dir.chdir('app/assets/images/') do
      Dir['**/*.svg']
    end
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
      head :forbidden
    else
      head :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def page_scope
    "#{params[:controller].parameterize} #{params[:action].parameterize}"
  end

  def cache_url
    if params[:controller] == 'application'
      "/appcache" # domain
    elsif params[:id]
      "/#{params[:controller].parameterize}/#{params[:id]}/appcache" # member
    else
      "/#{params[:controller].parameterize}/appcache" # collection
    end
  end

  def bust_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end


  def cents_to_dollars(amount_in_cents)
    amount_in_dollars = "%.2f" % (amount_in_cents / 100.0)
  end

end
