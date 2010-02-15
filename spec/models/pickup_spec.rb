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

  it "should have an available list of members for its related farm" do
    pickup = Factory(:pickup, :farm => Factory(:farm_with_members))
    pickup.farm.members.size.should == 4
    pickup.farm.members.each do |u|
      thisfarm = false
      u.farms.each do |f|
        thisfarm = true if f.id == pickup.farm.id
      end
      thisfarm.should == true
    end
  end

  it "should generate with stock_items when a farm is passed to new" do
    farm = Factory(:farm_with_products)
    pickup = Pickup.new_from_farm(farm)
    
    pickup.stock_items.size.should_not == 0
    farm.products.size.should_not == 0
    pickup.stock_items.size.should == farm.products.size
  end
end
