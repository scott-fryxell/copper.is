class HomeController < ApplicationController
  respond_to :html

  def index
    if current_user
      @tip = Tip.new
      respond_with(@tip)
    end
  end

  def blog
    render :action => 'blog', :layout => true
  end


  def terms
    render :action => 'terms'
  end

  def privacy
    render :action => 'privacy'
  end

  def button
    render :action => 'button'
  end


  def safari
    send_file  Rails.public_path +  '/extensions/DirtyWhiteCouch.com.safariextz', :type => 'application/octet-stream', :disposition => 'inline', :filename=>'DirtyWhiteCouch.com.safariextz'
  end
end