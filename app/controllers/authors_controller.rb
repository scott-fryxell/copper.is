class AuthorsController < ApplicationController
  def edit
  end

  def update
    @user.update_attributes(params[:user])
    @user.email = params[:address] if params[:address]
    @user.email = params[:email] if params[:email]
    @user.save!
    render nothing:true, status:200
  end

  def show
    @recent_tip = current_user.tips.first
  end

end
