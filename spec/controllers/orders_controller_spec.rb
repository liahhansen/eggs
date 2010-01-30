require 'spec_helper'

describe OrdersController do

  it "should respond when requesting new with no pickup id" do
    get :new
    response.should be_success
  end

  it "should respond when requesting new with a pickup id" do
    get :new, :pickup_id => pickups(:sf_emeryville_feb3).id
    response.should be_success
  end

  it "should set a pickup when requesting new with a pickup id" do
    get :new, :pickup_id => pickups(:sf_emeryville_feb3).id
    assigns(:pickup).should == pickups(:sf_emeryville_feb3)
  end


end
