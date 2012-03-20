class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    # Find an identity here
    @identity = Identity.find_with_omniauth(auth)

    if @identity.nil?
      # If no identity was found, create a brand new one here
      @identity = Identity.create_with_omniauth(auth)
    end

    if current_user
      if @identity.user == current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it
        # is the current user. So the identity is already associated with
        # this user. So let's display an error message.

        redirect_to user_path(current_user.id), notice: "Already linked that account!"

      else
        # The identity is not associated with the current_user so lets
        # associate the identity
        @identity.user = current_user
        @identity.save()
        redirect_to user_path(current_user.id), notice: "Successfully linked that account"
      end
    else
      if @identity.user
        # The identity we found had a user associated with it so let's
        # just log them in here
        current_user = @identity.user

        set_cookie(@identity.user)

        redirect_to user_tips_path(current_user.id), notice: "Signed in!"
      else
        # No user associated with the identity so we need to create a new one
        user =  User.create_with_omniauth(auth)

        set_cookie(user)
        current_user = user

        @identity.user = current_user
        @identity.save()

        redirect_to button_path, notice: "Welcome aboard!"

      end
    end
  end

  def destroy
    if Rails.env.production?
      cookies[:user_id] = {:value => nil, :expires => 90.days.ago, :domain => '.copper.is'}
    else
      cookies[:user_id] = {:value => nil, :expires => 90.days.ago}
    end

    redirect_to root_url, :notice => "Signed out"
  end

  def failure
    # render :text => request.env["omniauth.auth"].to_yaml
    redirect_to root_url, :notice => params[:message]
  end

  def new
    render :action => 'new', :layout => 'sign_in'
  end

  private

  def set_cookie(user)
    if Rails.env.production?
      cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now, :domain => '.copper.is'}
    else
      cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
    end
  end
end
