class AuthorsController < ApplicationController
  filter_access_to :all
  filter_access_to :show, :update, :destroy, attribute_check:true

  def index
    if params[:state]
      @authors = Author.send(params[:state]).endless(params[:endless])
    elsif params[:user_id]
      @authors = Author.where(user_id:params[:user_id]).endless(params[:endless])
    elsif params[:page_id]
      @authors = Author.where(page_id:params[:page_id]).endless(params[:endless])
    else
      @authors = Author.twitter.stranger.pending_royalties.endless(params[:endless])
    end
    render action:'index', layout:false if request.headers['retrieve_as_data'] or params[:endless]
  end

  def show
    @author = Author.find(params[:id])
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  end

  def update
    @author = Author.find(params[:id])
    @author.update_attributes(params[:author])
    @author.save!
  end

  def destroy
    author = Author.find(params[:id])
    author.forget!
    render nothing:true, status:200
  end

  def enquire

    unless Author.providers.include?(params[:provider].to_sym)
      return render nothing:true, status:404
    end
    @author = Author.where(provider:params[:provider], username:params[:username]).first
    unless @author
      @author = Author.factory(provider:params[:provider],username:params[:username])
    end
  end

end