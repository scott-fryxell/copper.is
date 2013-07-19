class PagesController < ApplicationController
  filter_access_to :all
  filter_access_to :reject, :require => :manage

  def index
    if params[:state]
      @pages = Page.send(params[:state]).charged_tips.order_by_tips.endless(params[:endless])
    elsif params[:author_id]
      @pages = Page.where(author_id:params[:author_id]).endless(params[:endless])
    else
      @pages = Page.manual.charged_tips.order_by_tips.endless(params[:endless])
    end
    render :action => 'index', layout:false if request.headers['retrieve_as_data'] or params[:endless]
  end

  def show
    @page = Page.find(params[:id])
    if request.headers['retrieve_as_data']
      render :action => 'show', layout:false
    else
      render :action => 'show', layout:"page_layout"
    end
  end

  def update
    @page = Page.find(params[:id])

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

    if params[:author_url]
      if @page.author = Author.find_or_create_from_url(params[:author_url])
        @page.adopt!
      end
    end

    @page.save
    render :action => 'update', :layout => false
  end

  def reject
    @page = Page.find(params[:id])
    @page.reject!
    render :action => 'update', :layout => false
  end

end
