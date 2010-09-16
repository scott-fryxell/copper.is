class HomeController < ApplicationController
  def index
    if request.xhr?
      render :action => 'index_ajax', :layout => false
    end
  end
end