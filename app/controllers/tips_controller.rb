class TipsController < ApplicationController
  filter_resource_access

  # GET /tips
  # GET /tips.xml  
  def index
    @tips = Tip.find_all_by_user_id(current_user)
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
    @title = params[:title]
    
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
    @tip = Tip.new(params[:tip])

    @tip.user_id = current_user.id
      
    
    @tip_url = URI.split(@tip.url)
    # todo put tipped url's into the resources table
    # @resource = Resource.new
    # 
    # @resource.scheme   = @tip_url.scheme
    # @resource.userinfo = @tip_url.userinfo
    # @resource.host     = @tip_url.host
    # @resource.port     = @tip_url.port
    # @resource.registry = @tip_url.registry
    # @resource.path     = @tip_url.path
    # @resource.opaque   = @tip_url.opaque
    # @resource.query    = @tip_url.query
    # @resource.fragment = @tip_url.fragment
    # 
    # resource.save
    
    respond_to do |format|
      if @tip.save
        flash[:notice] = 'Tip was successfully created.'
        format.html { redirect_to(@tip) }
        format.xml  { render :xml => @tip, :status => :created, :location => @tip }
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
