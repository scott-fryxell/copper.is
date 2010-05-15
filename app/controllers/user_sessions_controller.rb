class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
    @user = User.new
  end
  
  def create
    if "yes" == params[:registered]
      @user_session = UserSession.create(params)
      if @user_session.valid?
        flash[:notice] = "Successfully logged in."
        redirect_to root_url
      else
        flash[:notice] = "We didn't recognize your email or password. Please try again."
        render :action => 'new'
      end
    else
      @user = User.new(params[:user])
      @user.roles = [Role.find_by_name("Patron")]
      if @user.save
        flash[:notice] = "Registration successful."
        redirect_to root_url
      else
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
