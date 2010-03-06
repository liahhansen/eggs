require 'spec_helper'

describe OrdersController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:user)
  end

  it "should render a delivery picker when requesting with no delivery id" do
    get :new
    response.should render_template("deliveries/delivery_selector_for_orders")
  end

  it "should respond when requesting new with a delivery id" do
    get :new, :delivery_id => Factory(:delivery).id
    response.should be_success
  end

  it "should set a delivery when requesting new with a delivery id" do
    p = Factory(:delivery)
    get :new, :delivery_id => p.id
    assigns(:delivery).should == p
  end

  it "should create new order_items when rendering 'new'" do
    p = Factory(:delivery_with_stock_items)
    get :new, :delivery_id => p.id

    assigns(:order).order_items.size.should == p.stock_items.size
  end

  it "should create new order_items when rendering 'create" do
    p = Factory(:delivery_with_stock_items)
    s1 = Factory(:stock_item)
    s2 = Factory(:stock_item)
    get :create, :delivery_id => p.id, :order => { :delivery_id => p.id,
            :order_items_attributes => {
                    "0" => {:stock_item_id => s1.id, :quantity => "2"},
                    "1" => {:stock_item_id => s2.id, :quantity => "0"}}}
    
    assigns(:order).order_items.size.should == 2
  end

  it "should set @member from current user when rendering new and there is no member_id in params" do
    p = Factory(:delivery_with_stock_items)
    get :new, :delivery_id => p.id
    assigns(:member).should == UserSession.find.user.member
  end

  it "should set @member from params if set when rendering new" do
    p = Factory(:delivery_with_stock_items)
    u = Factory(:member_user)
    get :new, :delivery_id => p.id, :member_id => u.id
    assigns(:member).should == u.member
  end

  it "should set @members from farm when rendering new with as_admin in params" do
    UserSession.create Factory(:admin_user)
    farm = Factory(:farm_with_members)
    delivery = Factory(:delivery_with_stock_items, :farm => farm)
    get :new, :delivery_id => delivery.id, :as_admin => true
    assigns(:member).should be_nil
    assigns(:members).size.should > 0
  end

  it "should set @member from order when rendering edit" do
    delivery = Factory(:delivery_with_stock_items)
    member = Factory(:member)
    order = Factory(:order_with_items, :member => member)

    get :edit, :id => order.id, :delivery_id => delivery.id
    assigns(:member).should == member
  end

  it "should only allow a member to create / edit orders for themselves" do
    pending
  end

  it "should render edit instead of new if an order for this delivery and user already exists" do
    pending
  end

  it "should require a user id when rendering any action except index" do
    pending
  end

end
