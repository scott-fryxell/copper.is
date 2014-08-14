class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  respond_to :html
  filter_access_to :all

  protect_from_forgery

  helper_method :current_user, :user_url, :set_scope, :cache_url, :cents_to_dollars, :icons
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
      render nothing:true, status:403
    else
      render nothing:true, status:401
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_scope
    "#{params[:controller].parameterize} #{params[:action].parameterize}"
  end

  def cache_url
    puts params
    if params[:controller] == 'application'
      "/appcache" # domain
    elsif params[:id]
      "/#{params[:controller].parameterize}/#{params[:id]}/appcache" # member
    else
      "/#{params[:controller].parameterize}/appcache" # collection
    end
  end

  def cents_to_dollars(amount_in_cents)
    amount_in_dollars = "%.2f" % (amount_in_cents / 100.0)
  end

end
