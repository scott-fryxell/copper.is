class TipsController < ApplicationController
  filter_access_to :index, :show, :create, :edit, :update, :destroy, :new, :attribute_check => false

  # GET /tips
  # GET /tips.xml
  def index
    @tip = Tip.new
    @tips = Tip.find_all_by_tip_bundle_id(current_user.tip_bundles.id)
    if @tips.nil?

    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tips }
    end
  end

  # GET /tips/1
  # GET /tips/1.xml
  def show
    @tip = Tip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tip }
    end
  end

  # GET /tips/new
  # GET /tips/new.xml
  def new
    @tip = Tip.new

    @current_user = current_user
    #@title = params[:title]

    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # GET /tips/1/edit
  def edit
    @tip = Tip.find(params[:id])
  end

  # POST /tips
  # POST /tips.xml
  def create
    @tip = Tip.build(current_user, params[:tip][:uri])

    respond_to do |format|
      if @tip.save
        flash[:notice] = t("weave.tip_success")
        format.html { redirect_to(tips_url) }
        #format.xml  { render :xml => @tip, :status => :created, :location => @tip }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tips/1
  # PUT /tips/1.xml
  # TODO verify that user is logged in before attempting to add tip
  def update
    @tip = Tip.find(params[:id])
    @tip.user_id = current_user.id
    respond_to do |format|
      if @tip.update_attributes(params[:tip])
        flash[:notice] = 'Tip was successfully updated.'
        format.html { redirect_to(@tip) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tip.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tips/1
  # DELETE /tips/1.xml
  def destroy
    @tip = Tip.find(params[:id])
    @tip.destroy

    respond_to do |format|
      format.html { redirect_to(tips_url) }
      format.xml  { head :ok }
    end
  end

end
