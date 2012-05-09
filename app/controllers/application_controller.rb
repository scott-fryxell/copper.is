class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery
  
  # filter_access_to :all

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(cookies[:user_id]) if cookies[:user_id]
  end

  protected

  def permission_denied
    flash[:message] = t("copper.permission_denied")
    if current_user
      respond_to do |format|
        format.html { render nothing:true, status:403 }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    else
      respond_to do |format|
        format.html { redirect_to signin_url }
        format.xml  { head :unauthorized }
        format.js   { head :unauthorized }
      end
    end
  end

end
