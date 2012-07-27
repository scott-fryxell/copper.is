class HomeController < ApplicationController
  respond_to :html

  def index
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

  def how
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