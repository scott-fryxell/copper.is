class TipsController < ApplicationController
  filter_resource_access
  
  before_filter :set_page
  before_filter :set_user

  def index
    if params[:user_id]
      @tips = current_user.current_tips
    else
      @tips = Tip.all
      unless current_user
        @tips.each do |t|
          t.order_id = nil
          t.check_id = nil
        end
      end
    end
    respond_to do |format|
      format.html
      format.json { render :json => @tips }
    end
  end

  def show
    @tip = Tip.find(params[:id])
    unless current_user
      @tip.order_id = nil
      @tip.check_id = nil
    end
    respond_to do |format|
      format.html
      format.json { render :json => @tip }
    end
  end

  def new
    @tip = current_user.tips.build
    render nothing:true
  end

  def create
    @tip = current_user.tip(params[:tip])
    if @tip && @tip.valid?
      redirect_to user_tips_url(current_user.id), :notice => t("copper.tip_success")
    else
      redirect_to user_tips_url(current_user.id), :notice => t("copper.tip_failed")
    end
  rescue ActiveRecord::RecordInvalid
    render nothing:true, status:403
  end

  def edit
    @tip = current_user.tips.find(params[:id])
    render :nothing => true
  end

  def update
    @tip = current_user.tips.find(params[:id])
    if params[:tip][:amount_in_cents] && params[:tip][:amount_in_cents] != ""
      @tip.amount_in_cents = params[:tip][:amount_in_cents]
      @tip.save
    end
    if request.xhr?
      render :text => '<meta name="event_trigger" content="tip_updated"/>'
    else
      redirect_to tips_path(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => :unauthorized
  end

  def destroy
    tip = current_user.tips.find(params[:id])
    if(tip.order.user == current_user and tip.order.current?)
      tip.destroy
    end
    render :nothing => true, :status => :ok
  rescue ActiveRecord::RecordNotFound
    render :nothing => true, :status => :unauthorized
  rescue CantDestroyException
    redirect_to tips_path, notice:'Tips can not be changed after they have been paid for'
  end


  # def agent
  #   uri = URI.unescape(params[:uri]) rescue params[:uri]
  #   title = URI.unescape(params[:title]) rescue params[:title]
  #   @tip = current_user.tip(url:uri, title:title )

  #   if @tip && @tip.valid?
  #     render :action => 'show', :layout => 'button'
  #   else
  #     render :action => 'error', :layout => 'button'
  #   end
  # rescue ArgumentError => e
  #   logger.error e.message
  #   render :action => 'error', :layout => 'button'
  # end
  protected
  
  def set_page
    @page = Page.find(params[:page_id]) if params[:page_id]
  end
  
  def set_user
    @page = Page.find(params[:page_id]) if params[:page_id]
  end
end
