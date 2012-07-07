class UsersController < ApplicationController
  filter_resource_access

  def index
  end

  def new
  end

  def create
  end

  def update
    @user.update_attributes(params[:user])
    @user.save!
    render nothing:true, status:200
  end

  def edit
  end

  def show
  end

  def destroy
  end

  protected

  def load_user
    if params[:id] == 'me'
      if current_user
        @user = current_user
      else
        @user = User.new
      end
    else
      @user = User.find(params[:id])
    end
  end
end

