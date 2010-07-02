class AdminController < ApplicationController

  filter_access_to :home

  def home
  end

end