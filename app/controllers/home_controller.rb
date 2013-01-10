class HomeController < ApplicationController
  respond_to :html

  def index
    if current_user
      @pages = current_user.pages.group('pages.id').includes(:tips).except(:order).order('MAX(tips.created_at) DESC')
    else
      redirect_to :action => 'welcome', :status => 302
    end
  end

  def author
    @pages = Page.where(author_id: current_user.author_ids).includes(:tips)
  end

  def settings
  end

  def welcome
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

end