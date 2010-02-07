require 'spec_helper'

describe Pickup do
  before(:each) do
    @valid_attributes = {
      :farm_id => Factory(:farm).id
    }
  end

  it "should create a new instance given valid attributes" do
    Pickup.create!(@valid_attributes)
  end

  it "should return an estimated total for all orders" do
    pickup = Factory(:pickup_with_orders)
    pickup.estimated_total.should == pickup.orders.inject(0){|total, o| total + o.estimated_total}
  end

  it "should have an available list of users for its related farm" do
    pickup = Factory(:pickup, :farm => Factory(:farm_with_members))
    pickup.farm.users.size.should == 4
  end
end
