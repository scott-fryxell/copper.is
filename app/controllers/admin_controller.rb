class AdminController < ApplicationController
  filter_resource_access
  filter_access_to :index, :require => :read

  def index
  
  end

end
