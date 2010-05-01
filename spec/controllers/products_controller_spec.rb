require 'spec_helper'

describe ProductsController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
  end

  it "should use ProductsController" do
    controller.should be_an_instance_of(ProductsController)
  end

  it "should have a farm set by the application controller" do
    farm = Factory(:farm)
    get :index, :farm_id => farm.id
    response.should be_success
    assigns(:farm).should_not == nil
    assigns(:farm).should == farm
  end

  it "should only have products from the specified farm" do
    farm = Factory(:farm)
    Factory(:product, :farm_id => farm.id)
    Factory(:product, :farm_id => farm.id)
    Factory(:product, :farm => Factory(:farm))

    get :index, :farm_id => farm.id
    assigns(:products).size.should == 2
    assigns(:products).each do |product|
      product.farm_id.should == farm.id
    end
  end

end
