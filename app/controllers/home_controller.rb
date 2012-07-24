class HomeController < ApplicationController
  respond_to :html

  def iframe
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