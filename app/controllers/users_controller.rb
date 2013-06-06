class UsersController < ApplicationController
  filter_access_to :all

  def index
    @users = User.order("created_at DESC").limit(25)
    render :action => 'index', :layout => false if request.headers['retrieve_as_data']
  end

  def new
    @user = User.new
  end

  def create
  end

  def update

    if 'me' == params[:id]
      @user = current_user
    else
      @user = User.where(id:params[:id]).first()
    end

    @user.update_attributes(params[:user])
    @user.tip_preference_in_cents = params[:tip_preference_in_cents] if params[:tip_preference_in_cents]
    @user.email = params[:email] if params[:email]
    @user.save!
    render nothing:true, status:200
  end

  def edit
  end

  def show
    if params[:id] == 'me'
      @user = current_user
    else
      @user = User.where(id:params[:id]).first
    end
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  end

  def destroy
  end

end

