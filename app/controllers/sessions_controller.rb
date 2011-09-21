class SessionsController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    cookies[:user_id] = {:value => user.id, :expires => 90.days.from_now, :domain => '.dirtywhitecouch.com'}
    redirect_to tips_url, :notice => "Signed In!"
  end

  def destroy
    cookies.delete :user_id
    redirect_to root_url, :notice => "Signed out!"
  end  
  

  def new
   if request.xhr?
      render :action => 'new', :layout => false
    end
  end

end
