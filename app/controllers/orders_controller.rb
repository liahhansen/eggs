class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.xml
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new


    if params[:delivery_id]
      @delivery = Delivery.find(params[:delivery_id])
    else
      render :template => "deliveries/delivery_selector_for_orders"
      return
    end

    @order = Order.new_from_delivery(@delivery)

    if(params[:as_admin])
      @members = @delivery.farm.members
      @members.sort! { |a,b| a.last_name.downcase <=> b.last_name.downcase }

    else
      @member = params[:member_id] ? Member.find(params[:member_id]) : current_user.member
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @delivery = @order.delivery
    @member = @order.member
  end

  # POST /orders
  # POST /orders.xml
  def create
    @order = Order.new(params[:order])
    @member = @order.member
    
    respond_to do |format|
      if @order.save
        Notifier.deliver_order_confirmation(@order)
        flash[:notice] = 'Order was successfully created.'
        format.html { redirect_to order_path(:id => @order, :farm_id => @farm.id) }
        format.xml  { render :xml => @order, :status => :created, :location => @order }
      else
        @delivery = Delivery.find params[:delivery_id]
        format.html { render :action => "new" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])
    @delivery = @order.delivery
    @member = @order.member

    respond_to do |format|
      if @order.update_attributes(params[:order])
        Notifier.deliver_order_confirmation(@order, true)
        flash[:notice] = 'Order was successfully updated.'
        format.html { redirect_to order_path(:id => @order, :farm_id => @farm.id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    
    @order.destroy if @order.delivery.status == "open" || current_user.has_role?(:admin)

    respond_to do |format|

      if current_user.has_role?(:member)
        format.html { redirect_to root_path}
      else
        format.html { redirect_to delivery_path(:id => @order.delivery, :farm_id => @farm.id) }
        format.xml  { head :ok }
      end

    end
  end
end
