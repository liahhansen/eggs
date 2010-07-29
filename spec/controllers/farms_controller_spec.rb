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

  it "should create sets of deliveries when showing a single farm" do
    farm = Factory(:farm_with_deliveries)

    get :show, :id => farm.id
    response.should be_success

    assigns(:deliveries_inprogress).size.should == 2
    assigns(:deliveries_open).size.should == 1
    assigns(:deliveries_notyetopen).size.should == 1
    assigns(:deliveries_archived).size.should == 1
    assigns(:deliveries_finalized).size.should == 1
    
  end

  it "should update deliveries on show" do
    farm = Factory(:farm_with_deliveries)
    delivery = Factory(:delivery, :status => 'notyetopen', :opening_at => DateTime.now - 10.minutes, :farm => farm)

    get :show, :id => farm.id   

    delivery.reload
    delivery.status.should == 'open'

  end

end