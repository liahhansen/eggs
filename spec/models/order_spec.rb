require 'spec'
require 'spec_helper'

describe Order do
  before(:each) do
    @k_order = orders(:kathryn_sf_emeryville_feb3)
    @k_member = members(:kathryn)
    @e_pickup = pickups(:sf_emeryville_feb3)

    @valid_attributes = {
      :member_id => @k_member.id,
      :pickup_id => @e_pickup.id
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end

  it "should raise errors when saving when no member or pickup is specified" do
    Order.new.valid?.should == false
    lambda {Order.create!}.should raise_error
    lambda {Order.create!(:member_id => 1)}.should raise_error
    lambda {Order.create!(:pickup_id => 2)}.should raise_error
  end

  it "should only accept valid member and pickup ids" do
    lambda {Order.new(:member_id => 235, :pickup_id => 235).valid?}.should raise_error
    Order.new(:member_id => @k_member.id, :pickup_id => @e_pickup.id).valid?.should == true    
  end

  it "should return an estimated order total" do
    order= @k_order
    order.estimated_total.should == 91    
  end

  it "should destroy order_items when destroying order" do
    order = @k_order
    order.destroy.frozen?.should == true

    order.order_items.each do |item|
      item.frozen?.should == true
    end
  end

end
