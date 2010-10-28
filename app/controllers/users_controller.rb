class UsersController < ApplicationController
  filter_access_to :all

  def new
    @user = User.new
  end

  def create
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def update_password
    @user = current_user

    @salt = @user.password_salt
    @password_encrypted = Authlogic::CryptoProviders::Sha512.encrypt(params[:user][:current_password] + @salt)

    if @password_encrypted != @user.crypted_password
      flash[:notice] = t("weave.current_password_is_invalid")
      render :action => :edit
    elsif params[:user][:password].blank? || ( params[:user][:password].blank? && params[:user][:password_confirmation].blank? )
      flash[:notice] = t("weave.password_too_short")
      render :action => :edit
    else
      if @user.update_attributes(params[:user])
        flash[:notice] = t("weave.successfully_updated_password")
        render :action => :edit
      else
        flash[:notice] = @user.errors.full_messages
        render :action => :edit
      end
    end
  end

  def update_email_name
    @user = current_user
    if @user.update_attributes(params[:user])
      @user.name = params[:user][:name] # why doesn't update_attributes work?
      @user.save
      flash[:notice] = t("weave.successfully_updated_user")
      render :edit
    else
      flash[:notice] = @user.errors.full_messages
      render :action => :edit
    end
  end

end
