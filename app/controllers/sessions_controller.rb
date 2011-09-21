class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    # session[:user_id] = user.id
    cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now}
    redirect_to tips_url, :notice => "Signed In!"
  end

  def destroy
    # session[:user_id] = nil
    cookies[:user_id] = {:value => nil, :expires => 90.days.ago}
    redirect_to root_url, :notice => "Signed out!"
  end  
  

  def new
   if request.xhr?
      render :action => 'new', :layout => false
    end
  end

end
