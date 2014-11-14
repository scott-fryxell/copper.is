class SessionsController < ApplicationController

  def create

    auth = request.env['omniauth.auth']

    @author = Author.find_or_create_by_authorization(auth)

    if current_user
      @author.user = current_user # associate the author with the current user
    else

      unless @author.user
        @author.user = User.create_with_omniauth(auth) # create a user and assign it to author
      end

      session[:user_id] = @author.user.id # Log them in. author has a user associateds
    end
    @author.join!
    redirect_to request.env['omniauth.origin'] || root_url
  end

  def destroy
    session[:user_id] = nil
    reset_session

    if redirect_to = params[:redirect_to]
      redirect_to redirect_to, notice: "goodbye pretty"
    else
      redirect_to root_url, notice: "goodbye pretty"
    end
  end

  def failure
    # render :text => request.env["omniauth.auth"].to_yaml
    # TODO: maybe actually send a message here
  end

end
