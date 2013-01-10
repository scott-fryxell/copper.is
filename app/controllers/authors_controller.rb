class AuthorsController < ApplicationController
  filter_resource_access

  def index
    @authors = current_user.authors
  end

  def new
  end

  def show
    @authors = current_user.authors.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render nothing:true, status:401
  end

  def edit
  end

  def create
  end
  
  def update
  end

  def destroy
    author = Author.find(params[:id])
    author.remove_user!
    render nothing:true, status:200
  end
end
