class UsersController < ApplicationController
  filter_resource_access

  def new
    @user = User.new
  end

  def create
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user][:password].blank? || ( params[:user][:password].blank? && params[:user][:password_confirmation].blank? )
      flash[:notice] = t("weave.password_too_short")
      render :action => :edit
    else
      if @user.update_attributes(params[:user])
        flash[:notice] = t("weave.successfully_updated_user")
        redirect_to root_url
      else
        flash[:notice] = @user.errors.full_messages
        render :action => :edit
      end
    end
  end
end
