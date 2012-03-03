class TipsController < ApplicationController
  filter_access_to :create, :update, :destroy, :embed_iframe, :agent, :attribute_check => false
  def index
    @user = current_user
    @tip = Tip.new

    if params[:all] == 'true'
      @tips = current_user.tips
    else
      @tips = current_user.active_tips
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user.to_xml }
      format.json  { render :json => @user.to_json }
    end
    
  end

  def create
    if request.xhr?
      @tip = current_user.tip(params[:uri], params[:title] )

      if @tip && @tip.valid?
        render :action => 'show', :layout => false
      else
        render :action => 'error', :layout => false
      end

    else
      @tip = current_user.tip(params[:tip][:uri])

      if @tip && @tip.valid?
        redirect_to user_url(current_user.id), :notice => t("copper.tip_success")
      else
        redirect_to user_url(current_user.id), :notice => t("copper.tip_failed")
      end
    end
  end
  def update
    @tip = Tip.find(params[:id])

    if params[:tip][:amount_in_cents] && params[:tip][:amount_in_cents] != ""
      @tip.amount_in_cents = params[:tip][:amount_in_cents]
      @tip.save
    end

    if request.xhr?
      render :text => '<meta name="event_trigger" content="tip_updated"/>'
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
    @tip = current_user.tip(params[:uri], params[:title] )

    if @tip && @tip.valid?
      render :action => 'show', :layout => 'button'
    else
      render :action => 'error', :layout => 'button'
    end
  end
end