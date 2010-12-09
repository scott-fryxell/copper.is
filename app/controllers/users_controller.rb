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

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user.to_xml }
      format.json  { render :json => @user.to_json }
    end

  end

  def edit
    @user = current_user
    @user.valid?
  end

  def update
    @user = current_user
    @user.tip_preference_in_cents = params[:user][:tip_preference_in_cents]

    if @user.save

      if request.xhr?
        render :action => 'update', :layout => false
      else
        flash[:notice] = "Successfully updated user."
        render :action => 'edit'
      end
    else
      if request.xhr?
        render :action => 'failed_update', :layout => false
      else
        flash[:notice] = "Unable to save user changes."
        render :action => 'edit'
      end
    end
  end
end