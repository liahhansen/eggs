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
    get :create, :pickup_id => p.id
    assigns(:order).order_items.size.should == p.stock_items.size
  end
end
