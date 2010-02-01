require 'spec_helper'

describe OrdersController do

  it "should render a pickup picker when requesting with no pickup id" do
    get :new
    response.should render_template("pickups/pickup_selector_for_orders")
  end

  it "should respond when requesting new with a pickup id" do
    get :new, :pickup_id => pickups(:sf_emeryville_feb3).id
    response.should be_success
  end

  it "should set a pickup when requesting new with a pickup id" do
    get :new, :pickup_id => pickups(:sf_emeryville_feb3).id
    assigns(:pickup).should == pickups(:sf_emeryville_feb3)
  end

  it "should create new order_items when rendering 'new'" do
    get :new, :pickup_id => pickups(:sf_emeryville_feb3).id
    assigns(:order).order_items.size.should == 2
  end

end
