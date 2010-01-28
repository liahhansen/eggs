class StockItemsController < ApplicationController
  # GET /stock_items
  # GET /stock_items.xml
  def index
    redirect_to root_path
  end

  # GET /stock_items/1
  # GET /stock_items/1.xml
  def show
    @stock_item = StockItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock_item }
    end
  end

  # GET /stock_items/new
  # GET /stock_items/new.xml
  def new
    @stock_item = StockItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock_item }
    end
  end

  # GET /stock_items/1/edit
  def edit
    @stock_item = StockItem.find(params[:id])
  end

  # POST /stock_items
  # POST /stock_items.xml
  def create
    @stock_item = StockItem.new(params[:stock_item])

    respond_to do |format|
      if @stock_item.save
        flash[:notice] = 'StockItem was successfully created.'
        format.html { redirect_to(@stock_item) }
        format.xml  { render :xml => @stock_item, :status => :created, :location => @stock_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stock_items/1
  # PUT /stock_items/1.xml
  def update
    @stock_item = StockItem.find(params[:id])

    respond_to do |format|
      if @stock_item.update_attributes(params[:stock_item])
        flash[:notice] = 'StockItem was successfully updated.'
        format.html { redirect_to(@stock_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stock_items/1
  # DELETE /stock_items/1.xml
  def destroy
    @stock_item = StockItem.find(params[:id])
    @stock_item.destroy

    respond_to do |format|
      format.html { redirect_to(stock_items_url) }
      format.xml  { head :ok }
    end
  end
end
