class HomeController < ApplicationController
  respond_to :html

  def iframe
    render :action => 'embed_iframe', :format => [:js], :layout => false
  end

end