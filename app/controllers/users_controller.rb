class UsersController < ApplicationController
  filter_access_to :all

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = "Successfully registered user."
      redirect_to account_path
    else
      render :action => 'new'
    end
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
    @user.valid?
  end

  def update
    @user = current_user
    @user.attributes = params[:user]
    if @user.save
      flash[:notice] = "Successfully updated user."
      redirect_back_or_default account_path
    else
      render :action => 'edit'
    end
  end
end