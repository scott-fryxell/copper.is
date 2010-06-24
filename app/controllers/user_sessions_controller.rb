class UserSessionsController < ApplicationController
  filter_resource_access
  
  def new
    @user_session = UserSession.new
    @user = User.new
  end
  
  def create
    if "yes" == params[:registered]
      @user_session = UserSession.create(params[:user])
      if @user_session.valid?
        flash[:notice] = t("weave.login_success")
        redirect_to root_url
      else
        flash[:error] = @user_session.errors.full_messages
        render :action => 'new'
      end
    else
      @user = User.new(params[:user])
      @user.roles << Role.find_by_name("Patron")
      if @user.save_without_session_maintenance
        @user.deliver_user_activation!
        flash[:notice] = t("weave.registration_success")
        redirect_to root_url
      else
        flash[:error] = @user.errors.full_messages
        render :action => 'new'
      end
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = t("weave.logout_success")
    redirect_to root_url
  end
end
