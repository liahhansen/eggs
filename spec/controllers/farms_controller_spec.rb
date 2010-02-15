require 'spec'
require 'spec_helper'

describe FarmsController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
  end


  it "should succeed if we are authenticated" do
    get :index
    response.should be_success
  end

  it "should fail" do
    fail
  end

  it "should create sets of pickups when showing a single farm" do
    farm = Factory(:farm_with_pickups)

    get :show, :id => farm.id
    response.should be_success

    assigns(:pickups_inprogress).size.should == 2
    assigns(:pickups_open).size.should == 1
    assigns(:pickups_notyetopen).size.should == 1
    assigns(:pickups_archived).size.should == 1
    assigns(:pickups_finalized).size.should == 1
    
  end

end