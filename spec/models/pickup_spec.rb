require 'spec_helper'

describe Pickup do
  before(:each) do
    @valid_attributes = {
      :farm_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Pickup.create!(@valid_attributes)
  end

  it "should return an estimated total for all orders" do
    pickup = pickups(:sf_emeryville_feb3)
    pickup.estimated_total.should == 91 
  end
end
