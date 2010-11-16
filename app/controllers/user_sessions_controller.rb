class UserSessionsController < ApplicationController
  filter_resource_access

  def new
    @user_session = UserSession.new
    @user = User.new

    if request.xhr?
      render :action => 'new_ajax', :layout => false
    end

    render :action => 'new', :layout => 'layouts/signup'
  end

  def create
    if "yes" == params[:registered]
      @user_session = UserSession.create(params[:user])
      if @user_session.valid?
        flash[:notice] = t("weave.login_success")
        if request.xhr?
          render :action => 'success', :layout => false
        else
          redirect_to :controller => 'tips', :action => 'index'
        end
      else
        flash[:error] = @user_session.errors.full_messages
        if request.xhr?
          render :action => 'new_ajax', :layout => false
        else
          render :action => 'new', :layout => 'layouts/signup'
        end
      end

    else
      @user = User.new(params[:user])
      @user.roles << Role.find_by_name("Patron")
      if @user.save_without_session_maintenance
        @user.deliver_user_activation!
        flash[:notice] = t("weave.registration_success")
        redirect_to root_url
      else
        flash[:error] = @user.errors.full_messages
        render :action => 'new'
      end
    end
  end

  def fb_authenticate
    @user_session = UserSession.new(params[:user_session])

    if @user_session.save
      flash[:notice] = "Sign in successful!"
      respond_to do |format|
        format.html { redirect_to root_url }
      end
    else
      respond_to do |format|
        format.html { render :action => :new }
      end
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = t("weave.logout_success")
    redirect_to root_url
  end

end
