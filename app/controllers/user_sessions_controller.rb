class UserSessionsController < ApplicationController
  filter_resource_access
  
  def new
    @user_session = UserSession.new
    @user = User.new
  end
  
  def create
    if "yes" == params[:registered]
      @user_session = UserSession.create(params[:user])
      if @user_session.valid?
        flash[:notice] = "Successfully logged in."
        redirect_to root_url
      else
        flash[:error] = "We didn't recognize your email or password. Please try again."
        render :action => 'new'
      end
    else
      @user = User.new(params[:user])
      @user.roles << Role.find_by_name("Patron")
      if @user.save
        @user_session = UserSession.create(params[:user])
        if @user_session.valid?
          flash[:notice] = "Registration successful."
          redirect_to root_url
        else
          flash[:error] = "Login failed."
          render :action => 'new'
        end
      else
        flash[:error] = @user.errors.full_messages
        render :action => 'new'
      end
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
end
