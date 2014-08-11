class AuthorsController < ApplicationController

  def authorize_facebook_privelege
    # :scope => 'email, offline_access, user_likes, publish_actions, manage_pages',
    request.env['omniauth.strategy'].options[:scope] = session[:fb_permissions]
    session.delete(:fb_permissions)
    render :text => "Setup complete.", :status => 404
  end

  def can_post_to_facebook
    session[:fb_permissions] = 'publish_actions'
    redirect_to '/auth/facebook'
  end

  def can_view_facebook_pages
    session[:fb_permissions] = 'manage_pages'
    redirect_to '/auth/facebook'
  end

  def claim_facebook_pages
    if pages = params[:facebook_objects]

      facebook = Author.where(provider:"facebook", user_id:current_user.id).first
      graph = Koala::Facebook::API.new(facebook.token)

      pages.each  do |id|
        fb_page =  graph.get_object(id)
        another_me = Author.find_or_create_from_url(fb_page['link'])
        another_me.user = current_user
        another_me.join!
      end
    end
    head :ok
  end



end
