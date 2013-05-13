class PagesController < ApplicationController
  filter_access_to :all

  def index
    if params[:state]
      @pages = Page.send(params[:state]).limit(300).recent 
    elsif params[:author_id]
      @pages = Page.where(author_id:params[:author_id])
    else
      @pages = Page.recent.limit(300)
    end
    render :action => 'index', :layout => false if request.headers['retrieve_as_data']
  end

  def show
    @page = Page.where(id:params[:id]).first
    render :action => 'show', :layout => false if request.headers['retrieve_as_data']
  end

  def update
    @page = Page.where(id:params[:id]).first

    if params[:thumbnail_url] 
      if params[:thumbnail_url].length > 0
        @page.thumbnail_url = params[:thumbnail_url]
      else
        @page.thumbnail_url = nil
      end
    end

    if params[:title] and params[:title].length > 0
      @page.title = params[:title]
    end

    if params[:url] and params[:url].length > 7
      @page.url = params[:url]
    end

    if params[:onboarding]
      @page.onboarding = params[:onboarding]
    end

    if params[:nsfw]
      @page.nsfw = params[:nsfw]
    end

    if params[:welcome]
      @page.welcome = params[:welcome]
    end

    if params[:trending]
      @page.trending = params[:trending]
    end

    @page.save
    render :action => 'update', :layout => false 
  end

  def create
  end

  def destroy
  end
end
