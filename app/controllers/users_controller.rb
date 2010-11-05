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
        flash[:notice] = t("weave.password_update_success")
        render :action => :edit
      else
        flash[:notice] = @user.errors.full_messages
        render :action => :edit
      end
    end
  end

  def update_user
    @user = current_user
    if params[:user][:email] == @user.email
      @user.name = params[:user][:name] # why doesn't update_attributes work?
      @user.save
      flash[:notice] = t("weave.user_update_success")
      render :edit
    # section that handles email changes
    elsif params[:user][:email] != @user.email && !params[:user][:email].blank?
      @user.name = params[:user][:name] # set any vars other than email
      if @user.new_email_submit(params[:user][:email])
        flash[:notice] = t("weave.email_change_needs_confirmation", :new_email => @user.new_email)
        render :edit
      else
        flash[:notice] = @user.errors.full_messages
        render :action => :edit
      end
    else
      flash[:notice] = @user.errors.full_messages
      render :action => :edit
    end
  end

  def confirm_new_email
    @user = User.find_by_new_email_token(params[:id]) # we could add a timeout on the token, say 1 week with: (params[:id], 1.week)
    if @user && @user == current_user
      if @user.new_email_confirmed!
        flash[:notice] = t("weave.email_changed")
        render :action => 'edit'
      else
        flash[:notice]  = t("weave.email_change_failure")
        render :action => 'edit'
      end
    else
      @user = current_user
      flash[:notice]  = t("weave.email_change_failure")
      render :action => 'edit'
    end
  end

end