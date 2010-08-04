class UserActivationsController < ApplicationController

  def activate
    @user = User.find_using_perishable_token(params[:id]) # we could add a timeout on the token, say 1 week with: (params[:id], 1.week)
    if @user
      if @user.active?
        flash[:notice] = t("weave.account_already_active")
        redirect_to login_url
      else
        if @user.activate!
          flash[:notice] = t("weave.account_activated")
          UserSession.create(@user, false)
          @user.deliver_user_welcome!
          redirect_to instructions_url
        else
          flash[:notice]  = t("weave.activation_failed")
          render :action => 'new'
        end
      end
    else
      flash[:notice]  = t("weave.activation_failed")
      render :action => 'new'
    end
  end

  def send_activation
    @user = User.find_by_email(params[:email])
    if @user
      if @user.active?
        flash[:notice] = t("weave.account_already_active")
        redirect_to login_url
      else
        @user.deliver_user_activation!
        flash[:notice] = t("weave.activation_requested")
        redirect_to root_url
      end
    else
      flash[:notice] = t("weave.email_not_found")
      render :action => 'new'
    end
  end

end