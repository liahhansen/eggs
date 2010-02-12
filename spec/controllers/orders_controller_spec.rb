require 'spec_helper'

describe OrdersController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:user)
  end

  it "should render a pickup picker when requesting with no pickup id" do
    get :new
    response.should render_template("pickups/pickup_selector_for_orders")
  end

  it "should respond when requesting new with a pickup id" do
    get :new, :pickup_id => Factory(:pickup).id
    response.should be_success
  end

  it "should set a pickup when requesting new with a pickup id" do
    p = Factory(:pickup)
    get :new, :pickup_id => p.id
    assigns(:pickup).should == p
  end

  it "should create new order_items when rendering 'new'" do
    p = Factory(:pickup_with_stock_items)
    get :new, :pickup_id => p.id

    assigns(:order).order_items.size.should == p.stock_items.size
  end

  it "should create new order_items when rendering 'create" do
    p = Factory(:pickup_with_stock_items)
    s1 = Factory(:stock_item)
    s2 = Factory(:stock_item)
    get :create, :pickup_id => p.id, :order => { :pickup_id => p.id,
            :order_items_attributes => {
                    "0" => {:stock_item_id => s1.id, :quantity => "2"},
                    "1" => {:stock_item_id => s2.id, :quantity => "0"}}}
    
    assigns(:order).order_items.size.should == 2
  end

  it "should set @member from current user when rendering new and there is no user_id in params" do
    p = Factory(:pickup_with_stock_items)
    get :new, :pickup_id => p.id
    assigns(:member).should == UserSession.find.user
  end

  it "should set @member from params if set when rendering new" do
    p = Factory(:pickup_with_stock_items)
    u = Factory(:member_user)
    get :new, :pickup_id => p.id, :user_id => u.id
    assigns(:member).should == u
  end

  it "should set @member from order when rendering edit" do
    p = Factory(:pickup_with_stock_items)
    u = Factory(:member_user)
    o = Factory(:order_with_items, :user => u)

    get :edit, :id => o.id, :pickup_id => p.id
    assigns(:member).should == u
  end

  it "should only allow a member to create / edit orders for themselves" do
    pending
  end

  it "should render edit instead of new if an order for this pickup and user already exists" do
    pending
  end

  it "should require a user id when rendering any action except index" do
    pending
  end

end
