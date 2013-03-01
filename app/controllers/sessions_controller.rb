class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    puts auth.to_yaml
    # Find an author here
    @author = Author.find_with_omniauth(auth)

    if @author.nil?
      # If no author was found, create a brand new one here
      @author = Author.create_with_omniauth(auth)
    end

    @author.token = auth['credentials']['token']
    @author.secret = auth['credentials']['secret']
    @author.username = auth['info']['nickname']
    @author.save
    Resque.enqueue @author.class, @author.id, :claim_pages


    if session[:fb_permissions] == 'publish_actions'
      session[:fb_permissions] = nil
      redirect_to '/settings#share' and return
    elsif session[:fb_permissions] == 'manage_pages'
      session[:fb_permissions] = nil
      redirect_to '/author#claim_pages' and return
    end

    if current_user
      if @author.user == current_user
        # User is signed in so they are trying to link an author with their
        # account. But we found the author and the user associated with it
        # is the current user. So the author is already associated with
        # this user. We take them back to their settings page
        
       redirect_to '/author'

      else
        # The author is not associated with the current_user so lets
        # associate the author
        @author.user = current_user
        @author.join!
        @author.save()
        redirect_to '/author'
      end
    else
      if @author.user
        @author.join!
        # The author we found had a user associated with it so let's
        # just log them in
        current_user = @author.user
        @author.join!
        session[:user_id] = @author.user.id

        redirect_to "#{root_url}#me"
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
          redirect_to "#{root_url}#me"
        end
      end
    end
  end

  def destroy
    session[:user_id] = nil
    reset_session
    redirect_to root_url
  end

  def failure
    # render :text => request.env["omniauth.auth"].to_yaml
    # redirect_to root_url, :notice => params[:message]
    redirect_to root_url
  end

  def publish_actions
    session[:fb_permissions] = 'publish_actions'
    redirect_to '/auth/facebook'
  end

  def manage_pages
    session[:fb_permissions] = 'manage_pages'
    redirect_to '/auth/facebook'
  end

  def facebook_setup
    # :scope => 'email, offline_access, user_likes, publish_actions, manage_pages',
    request.env['omniauth.strategy'].options[:scope] = session[:fb_permissions]
    render :text => "Setup complete.", :status => 404
  end

  def new
  end
end
