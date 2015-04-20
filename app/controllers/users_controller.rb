class UsersController < ApplicationController
  filter_access_to :all
  filter_access_to :update, attribute_check:true
  def index
    @users = User.order("created_at DESC").endless(params[:endless])
    render :action => 'index', :layout => false if request.headers['retrieve_as_data'] or params[:endless]
  end

  def update
    if 'me' == params[:id]
      @user = current_user
    else
      @user = User.find(params[:id])
    end

    @user.update_attributes(params[:user])
    @user.tip_preference_in_cents = params[:tip_preference_in_cents] if params[:tip_preference_in_cents]
    @user.email = params[:email] if params[:email]
    @user.save!
    render nothing:true, status:200
  end

  def show
    if params[:id] == 'me'
      @user = current_user
    else
      @user = User.find(params[:id])
    end
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  end
end