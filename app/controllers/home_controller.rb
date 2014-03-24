class HomeController < ApplicationController
  filter_access_to :author, :require => :read
  filter_access_to :settings, :require => :read
  filter_access_to :claim_facebook_pages, :require => :read
  filter_access_to :integrations, :require => :manage
  respond_to :html

  def index
  end

  def author
  end

  def settings
  end

  def getting_started
  end

  def badge
  end

  def tip_some_pages
  end

  def integrations
  end

  def tipped
    response.headers['Cache-Control'] = 'public, max-age=300'
  end

  def about
    response.headers['Cache-Control'] = 'public, max-age=300'
  end

  def faq
    response.headers['Cache-Control'] = 'public, max-age=300'
  end

  def privacy
    response.headers['Cache-Control'] = 'public, max-age=300'
  end

  def terms
    response.headers['Cache-Control'] = 'public, max-age=300'
  end

  def contact
    response.headers['Cache-Control'] = 'public, max-age=300'
  end

  def iframe
    response.headers['Cache-Control'] = 'public, max-age=300'
    render :action => 'embed_iframe', :format => [:js], :layout => false
  end

  def test
    render :action => 'test', :layout => false
  end

  def states
    @country = Country.coded(params['country_code'])
    if @country.subregions?
      render :action => 'states', :layout => false
    else
      render nothing:true, status:200
    end
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
