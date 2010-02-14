require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :first_name => "Timothy",
      :last_name => "Riggins",
      :username => "DillonFootballRules",
      :email_address => "tim@riggins.net",
      :phone_number => "512-353-3694",
      :password => "gopanthers",
      :password_confirmation => "gopanthers",
      :neighborhood => "dillon"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should return only the orders for a specific farm" do
    user = Factory(:user_with_orders_from_2_farms)
    user.orders.size.should == 2
    user.orders.filter_by_farm(user.farms.first).size.should == 1
  end
end
