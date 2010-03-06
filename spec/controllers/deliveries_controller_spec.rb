require 'spec_helper'

describe DeliveriesController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:user)
  end  

  it "should list deliveries only for soul food farm" do
    get :index, :farm_id => Factory(:farm)

    response.should be_success

    assigns(:deliveries).each do |p|
      p.farm.should == Factory(:farm)
    end

  end

  it "should redirect index if no farm id is given" do
    get :index

    response.should be_redirect
    
  end

end
