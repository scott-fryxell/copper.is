class PagesController < ApplicationController
  filter_resource_access

  def index
    @pages = Page.all
  end

  def show
  end

  def new
  end

  def create
  end

  def destroy
  end
end
