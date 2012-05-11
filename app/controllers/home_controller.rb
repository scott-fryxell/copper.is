class HomeController < ApplicationController
  respond_to :html

  def iframe
    render :action => 'embed_iframe.js', :layout => false
  end

end