class UserSessionsController < ApplicationController
  # filter_resource_access

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if @user_session.new_registration?
        flash[:notice] = t('authlogic.registration_new')
        redirect_to edit_user_path( :current )
      else
        if @user_session.registration_complete?
          flash[:notice] = t('authlogic.signin_success')
          redirect_to tips_path
        else
          flash[:notice] = t('authlogic.account_review')
          redirect_to edit_user_path( :current )
        end
      end
    else
      flash[:notice] = t('authlogic.failed_signin')
      redirect_to root_url
    end
  end

  def destroy
    @user_session = current_user_session
    @user_session.destroy if @user_session
    flash[:notice] = t("authlogic.signout_success")
    redirect_to root_url
  end
end
