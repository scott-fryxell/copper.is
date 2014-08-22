class SessionsController < ApplicationController

  def create

    auth = request.env['omniauth.auth']
    @author = Author.find_or_create_by_authorization(auth)

    if session[:fb_permissions] == 'publish_actions'
      session.destroy(:fb_permissions)
      redirect_to '/my/authorizations#fb_permissions' and return
    elsif session[:fb_permissions] == 'manage_pages'
      session.destroy(:fb_permissions)
      redirect_to '/my/authorizations#fb_manage_pages' and return
    end

    if current_user
      if @author.user == current_user
        # User is signed in so they are trying to link an author with their
        # account. But we found the author and the user associated with it
        # is the current user. So the author is already associated with
        # this user.
      else
        # The author is not associated with the current_user so lets
        # associate the author
        @author.user = current_user
        @author.join!
        @author.save
      end
    else
      if @author.user
        @author.join!
        # The author we found had a user associated with it so let's
        # just log them in
        current_user = @author.user
        @author.join!
        session[:user_id] = @author.user.id
      else
        # No user associated with the author so we need to create a new one
        user = User.create_with_omniauth(auth)

        session[:user_id] = user.id #was author.user.id

        current_user = user

        @author.user = current_user

        if @author.wanted?
          @author.join!
          @author.save()
          redirect_to edit_author_url(@author)
        else
          @author.join!
          @author.save()
        end
      end
    end

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
