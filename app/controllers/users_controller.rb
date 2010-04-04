class UsersController < ApplicationController

  access_control do
    allow :admin
    allow :member, :to => [:show, :edit, :update]
  end

  # GET /users
  # GET /users.xml
  def index
    members = Member.all :joins => :subscriptions, :conditions => {:subscriptions => {:farm_id => @farm.id}}
    @users = User.all :conditions => ["member_id IN (?)", members]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @farm = @user.member.farms.first
    @subscription = Subscription.find_by_member_id_and_farm_id(@user.member.id,@farm.id)

    if(current_user == @user)
      orders = @user.member.orders.filter_by_farm(@farm)
      @open_orders = orders.select {|order| order.delivery.status == "open"}
      @finalized_orders = orders.select {|order|order.delivery.status == "finalized"}
      @inprogress_orders = orders.select {|order|order.delivery.status == "inprogress"}
      @archived_orders = orders.select {|order|order.delivery.status == "archived"}

      @open_deliveries = Delivery.find_all_by_farm_id_and_status(@farm.id, "open").reject do |delivery|
        has_order = false
        @open_orders.each do |order|
          if order.delivery == delivery
            has_order = true
            break
          end
        end
        has_order
      end

      render :template => "users/home"
      return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    if(current_user.has_role?(:admin))
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save_without_session_maintenance
        flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
        format.html { redirect_to root_url }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    if(current_user.has_role?(:admin))
      @user = User.find(params[:id])
    else
      @user = current_user
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])

        if @user == current_user
          flash[:notice] = "Thanks for updating your information!"
        else
          flash[:notice] = 'User was successfully updated.'
        end
        
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
