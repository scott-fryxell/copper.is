class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery

  helper_method :current_user

  private

  def current_user
    @current_user ||= User.find(cookies[:user_id]) if cookies[:user_id]
  end

  protected

  def permission_denied
    flash[:error] = t("dirtywhitecouch.permission_denied")
    respond_to do |format|
      format.html { redirect_to signin_url }
      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
    end
  end

end
