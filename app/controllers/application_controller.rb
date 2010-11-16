# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # ensure_application_is_installed_by_facebook_user

  before_filter :set_facebook_session
  helper_method :facebook_session

  helper_method :current_user
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    
    if facebook_session
      @current_user_session = facebook_session
    else
      @current_user_session = UserSession.find
    end
  end

  def current_user
    return @current_user if defined?(@current_user)
    
    if facebook_session
      @current_user = User.find_by_facebook_uid(facebook_session.user.uid)
    else
      @current_user = current_user_session && current_user_session.record
    end
    # @current_user = current_user_session && facebook_session.user
  end

  protected

  def permission_denied
    flash[:error] = t("weave.permission_denied")
    respond_to do |format|
      format.html { redirect_to root_url }
      format.xml  { head :unauthorized }
      format.js   { head :unauthorized }
    end
  end

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  filter_parameter_logging :fb_sig_friends
end
