class TipsController < ApplicationController
  filter_access_to :create, :update, :destroy, :embed_iframe, :agent, :attribute_check => false
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
        redirect_to user_url(current_user.id), :notice => t("dirtywhitecouch.tip_success")
      else
        redirect_to user_url(current_user.id), :notice => t("dirtywhitecouch.tip_failed")
      end
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