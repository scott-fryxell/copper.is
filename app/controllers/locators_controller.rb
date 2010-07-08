class LocatorsController < ApplicationController
  # GET /locators
  # GET /locators.xml
  filter_resource_access
  
  def index
    @locators = Locator.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locators }
    end
  end

  # GET /locators/1
  # GET /locators/1.xml
  def show
    @locator = Locator.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @locator }
    end
  end

  # GET /locators/new
  # GET /locators/new.xml
  def new
    @locator = Locator.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @locator }
    end
  end

  # GET /locators/1/edit
  def edit
    @locator = Locator.find(params[:id])
  end

  # POST /locators
  # POST /locators.xml
  def create
    @locator = Locator.new(params[:locator])

    respond_to do |format|
      if @locator.save
        flash[:notice] = 'Locator was successfully created.'
        format.html { redirect_to(@locator) }
        format.xml  { render :xml => @locator, :status => :created, :location => @locator }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @locator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locators/1
  # PUT /locators/1.xml
  def update
    @locator = Locator.find(params[:id])

    respond_to do |format|
      if @locator.update_attributes(params[:locator])
        flash[:notice] = 'Locator was successfully updated.'
        format.html { redirect_to(@locator) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @locator.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locators/1
  # DELETE /locators/1.xml
  def destroy
    @locator = Locator.find(params[:id])
    @locator.destroy

    respond_to do |format|
      format.html { redirect_to(locators_url) }
      format.xml  { head :ok }
    end
  end
end
