class TipsController < ApplicationController
  filter_access_to :index, :create, :edit, :update, :destroy, :new, :embed_iframe, :agent, :attribute_check => false
  def index
    @tip = Tip.new

    if params[:all]
      @tips = current_user.tips
    else
      @tips = current_user.active_tips
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
      format.json { render :json => @tips }
    end
  end
  def update
    @tip = Tip.find(params[:id])

    if params[:tip][:note] && params[:tip][:note] != ""
      @tip.note = params[:tip][:note]
      @tip.save
    end

    if request.xhr?
      render :action => 'notes_ajax', :layout => false
    end
  end
  def new
    @tip = Tip.new

    @user = current_user

    respond_to do |format|
      format.js
    end
  end
  def create
      if request.xhr?
        @tip = current_user.tip(params[:uri], params[:title] )
      else
        @tip = current_user.tip(params[:tip][:uri])
      end

      if @tip && @tip.valid?

        if request.xhr?
          render :action => 'show_ajax', :layout => false
        else
          redirect_to tips_url, :notice => t("dirtywhitecouch.tip_success")
        end
      else
        if request.xhr?
          render :action => 'error_ajax', :layout => false, :error => t("dirtywhitecouch.tip_failed")
        else
          redirect_to tips_url, :notice => t("dirtywhitecouch.tip_failed")
        end
      end
  end
  def destroy
    tip = Tip.find(params[:id])

    if(tip.tip_order.fan == current_user && tip.tip_order.is_active)
      tip.destroy
    end
    render :nothing => true, :status => :ok
  end
  def embed_iframe
    render :action => 'embed_iframe.js', :layout => false
  end
  def agent
    render :action => 'agent', :layout => false
  end
end