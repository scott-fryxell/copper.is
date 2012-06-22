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

  protected

  def load_user
    if params[:id] == 'me' or current_user.id.to_s == params[:id]
      @user = current_user
    else
      @user = User.new
    end
  end
end

