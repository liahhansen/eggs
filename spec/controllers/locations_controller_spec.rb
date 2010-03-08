require 'spec_helper'

describe LocationsController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
  end

  it "should have a farm set by the application controller" do
    farm = Factory(:farm)
    get :index, :farm_id => farm.id
    response.should be_success
    assigns(:farm).should_not == nil
    assigns(:farm).should == farm
  end

  it "should filter locations by farm" do
    farm = Factory(:farm)

    Factory(:location, :farm => farm, :name => "Potrero")
    Factory(:location, :farm => Factory(:farm), :name => "Elsewhere")

    get :index, :farm_id => farm.id
    response.should be_success
    assigns(:locations).each do |location|
      location.name.should_not == "Elsewhere"
    end

    assigns(:locations).size.should be > 0
  end
end