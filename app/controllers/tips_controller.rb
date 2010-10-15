class TipsController < ApplicationController
  filter_access_to :index, :show, :create, :edit, :update, :destroy, :new, :attribute_check => false

  def index
    @tip = Tip.new
    @tips = current_user.active_tips
    @has_funds = current_user.funds_for_tipping?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
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

  def show
    @tip = Tip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  def new
    @tip = Tip.new

    @current_user = current_user
    #@title = params[:title]
    @has_funds = current_user.funds_for_tipping?


    if @has_funds
      respond_to do |format|
        format.html # new.html.erb
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = t("weave.no_funds_for_tipping")
        format.html { redirect_to :controller => 'orders', :action => 'new'}#(orders_new_url) }
      end
    end
  end

  def create
    begin
      if request.xhr?
        @tip = current_user.tip(params[:uri], params[:title] )
      else
        @tip = current_user.tip(params[:tip][:uri])
      end

      if @tip && @tip.valid?

        if request.xhr?
          render :action => 'show_ajax', :layout => false
        else
          respond_to do |format|
            flash[:notice] = t("weave.tip_success")
            format.html { redirect_to :action => "index" }
            #format.xml  { render :xml => @tip, :status => :created, :location => @tip }
          end
        end
      else
        if request.xhr?
          flash[:error] = t("weave.tip_failed")
          render :action => 'error_ajax', :layout => false
        else
          respond_to do|format|
            flash[:error] = t("weave.tip_failed")
            format.html { redirect_to :action => "new" }
            #format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
          end
        end
      end

    rescue InsufficientFunds
      if request.xhr?
        render :action => 'funds_ajax', :layout => false
      else
        respond_to do |format|
          flash[:error] = t("weave.no_funds_for_tipping")
          format.html { redirect_to :controller => 'orders', :action => 'new'}#(orders_new_url) }
        end
      end
    end

  end
end
