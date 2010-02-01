require 'spec'
require 'spec_helper'

describe Order do
  before(:each) do

    @kathryn_order = orders(:kathryn_sf_emeryville_feb3)
    @kathryn = members(:kathryn)
    @emeryville_pickup = pickups(:sf_emeryville_feb3)

    @valid_attributes = {
      :member_id => @kathryn.id,
      :pickup_id => @emeryville_pickup.id,
      :order_items => get_order_items
    }
  end


  def get_order_core
    return Order.new(:member_id => @kathryn.id, :pickup_id => @emeryville_pickup.id)
  end

  def get_order_items
    return [order_items(:kathryn_feb3_chickenreg),order_items(:kathryn_feb3_eggs)]
  end

  def get_valid_order
    o = get_order_core
    o.order_items << get_order_items[0]
    o.order_items << get_order_items[1]
    return o
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
    get_valid_order.valid?.should == true    
  end

  it "should return an estimated order total" do
    order= @kathryn_order
    order.estimated_total.should == 91
  end

  it "should destroy order_items when destroying order" do
    order = @kathryn_order
    order.destroy.frozen?.should == true

    order.order_items.each do |item|
      item.frozen?.should == true
    end
  end

  it "should not be valid unless the order total is greater than the pickup minimum" do
    o = get_order_core
    o.order_items << order_items(:kathryn_feb3_eggs)
    o.valid?.should == false
    o.errors.on_base.should == "your order does not meet the minimum"

    o.order_items << order_items(:kathryn_feb3_chickenreg)
    o.valid?.should == true

  end

end
