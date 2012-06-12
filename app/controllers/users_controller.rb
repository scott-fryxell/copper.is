class UsersController < ApplicationController
  filter_resource_access

  def index
    redirect_to root_path
  end

  def new
    redirect_to root_path
  end

  def create
    redirect_to root_path
  end

  def update
    if @user = current_user
      if params[:id] == 'current' or @user.id.to_s == params[:id]
        @user.update_attributes(params[:user])
        @user.save!
        render nothing:true
      else
        render nothing:true, status:401
      end
    else
      render nothing:true, status:401
    end
  end

  def edit
    if @user = current_user
      if params[:id] == 'current' or @user.id.to_s == params[:id]
        if params[:author]
          render 'users/author'
        end

        @tips = @user.tips.all
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end

  def show
    @user = current_user
  end
end

