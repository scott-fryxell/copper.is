class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset!
      flash[:notice] = t("weave.password_reset_instructions_sent")
      redirect_to root_url
    else
      flash[:notice] = t("weave.email_not_found")
      render :action => :new
    end
  end

  def update
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = t("weave.password_changed")
      redirect_to root_url
    else
      flash[:notice] = @user.errors.full_messages
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = t("weave.account_not_located")
      redirect_to password_reset_new_url
    end
  end
end