class PickupsController < ApplicationController
  # GET /pickups
  # GET /pickups.xml
  def index

    if !params[:farm_id]
      redirect_to root_path
      return
    end

    @pickups = Pickup.find_all_by_farm_id(params[:farm_id])
    @farm = Farm.find(params[:farm_id])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pickups }
    end
  end

  # GET /pickups/1
  # GET /pickups/1.xml
  def show
    @pickup = Pickup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pickup }
    end
  end

  def show_sheet
    @pickup = Pickup.find(params[:id])
  end

  def edit_order_totals
    @pickup = Pickup.find(params[:id])
  end

  # GET /pickups/new
  # GET /pickups/new.xml
  def new
    @pickup = Pickup.new_from_farm(@farm)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pickup }
    end
  end

  # GET /pickups/1/edit
  def edit
    @pickup = Pickup.find(params[:id])
  end

  # POST /pickups
  # POST /pickups.xml
  def create
    @pickup = Pickup.new(params[:pickup])

    respond_to do |format|
      if @pickup.save
        flash[:notice] = 'Pickup was successfully created.'
        format.html { redirect_to :action => "show", :id => @pickup.id, :farm_id => @farm.id }
        format.xml  { render :xml => @pickup, :status => :created, :location => @pickup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pickup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pickups/1
  # PUT /pickups/1.xml
  def update
    @pickup = Pickup.find(params[:id])

    respond_to do |format|
      if @pickup.update_attributes(params[:pickup])
        flash[:notice] = 'Pickup was successfully updated.'
        format.html { redirect_to :action => "show", :id => @pickup.id, :farm_id => @farm.id }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pickup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pickups/1
  # DELETE /pickups/1.xml
  def destroy
    @pickup = Pickup.find(params[:id])
    @pickup.destroy

    respond_to do |format|
      format.html { redirect_to(@farm) }
      format.xml  { head :ok }
    end
  end
end
