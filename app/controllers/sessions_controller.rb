class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)

    if Rails.env.production?
      cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now, :domain => '.dirtywhitecouch.com'}
    else
      cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
    end

    redirect_to user_tips_path(current_user.id), :notice => "Signed In"
  end
  def destroy
    # session[:user_id] = nil
    if Rails.env.production?
      cookies[:user_id] = {:value => nil, :expires => 90.days.ago, :domain => '.dirtywhitecouch.com'}
    else
      cookies[:user_id] = {:value => nil, :expires => 90.days.ago}
    end

    redirect_to root_url, :notice => "Signed out"
  end
  def failure
    # render :text => request.env["omniauth.auth"].to_yaml
    redirect_to root_url, :notice => "Sign in failed"
  end
  def new
    render :action => 'new', :layout => false
  end
end
