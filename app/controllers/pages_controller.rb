class PagesController < ApplicationController
  filter_resource_access

  def index
  end

  def show
    render action:'show', layout:'page_layout'
  end

  def new
  end

  def create
  end

  def destroy
  end
end
