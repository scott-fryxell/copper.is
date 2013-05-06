class AdminController < ApplicationController
 filter_access_to :index, :require => :read

  def index  
  end

end
