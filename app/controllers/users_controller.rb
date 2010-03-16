class UsersController < ApplicationController
  
  filter_resource_access
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.roles = [Role.find_by_name("Patron")]
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to root_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
end
