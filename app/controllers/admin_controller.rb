class HomeController < ApplicationController
  filter_access_to :claim_facebook_pages, :require => :read
  filter_access_to :admin, :require => :manage
  respond_to :html

  def index
  end

  def admin
  end

  def iframe
    response.headers['Cache-Control'] = 'public, max-age=300'
    render :action => 'embed_iframe', :format => [:js], :layout => false
  end

  def test
    render :action => 'test', :layout => false
  end

  def claim_facebook_pages
    if pages = params[:facebook_objects]

      facebook = Author.where(provider:"facebook", user_id:current_user.id).first
      graph = Koala::Facebook::API.new(facebook.token)

      puts "getting facebook pages owned by author #{current_user.name}"
      pages.each  do |id|
        puts id
        fb_page =  graph.get_object(id)
        another_me = Author.find_or_create_from_url(fb_page['link'])

        another_me.user = current_user
        another_me.join!
      end
    end
    render nothing:true, status:200
  end

  def ping
    Page.count
    render action:'ping', layout:false
  end

end
