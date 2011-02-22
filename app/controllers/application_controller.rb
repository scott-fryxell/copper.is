class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery  

  helper_method :current_user, :current_user_session
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  protected

  def permission_denied
    flash[:error] = t("dirtywhitecouch.permission_denied")
    respond_to do |format|
      format.html { redirect_to root_url }
      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
    end
  end

end
