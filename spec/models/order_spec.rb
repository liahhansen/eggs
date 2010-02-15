# == Schema Information
#
# Table name: orders
#
#  id              :integer         not null, primary key
#  member_id       :integer
#  pickup_id       :integer
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  finalized_total :float
#

require 'spec'
require 'spec_helper'

describe Order do
  before(:each) do
    @valid_attributes = {
      :member_id => Factory(:member).id,
      :pickup_id => Factory(:pickup).id,
      :order_items => Factory(:order_with_items).order_items
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
    Factory(:order_with_items).valid?.should == true    
  end

  it "should be able to have order_items" do
    # actually a test for the factory
    order = Factory.build(:order_with_items)
    order.order_items.size.should >= 1
  end

  it "should return an estimated order total" do
    order = Factory.build(:order)
    order.order_items << Factory(:order_item)
    order.order_items << Factory(:order_item)
    order.estimated_total.should == 60
  end

  it "should destroy order_items when destroying order" do
    order = Factory.build(:order_with_items)
    order.destroy.frozen?.should == true

    order.order_items.each do |item|
      item.frozen?.should == true
    end
  end

  it "should not be valid unless the order total is greater than the pickup minimum" do
    p = Factory(:pickup, :minimum_order_total => 25)
    o = Factory.build(:order, :pickup => Factory(:pickup, :minimum_order_total => 25))
    o.order_items << Factory(:cheap_order_item)
    o.valid?.should == false
    o.errors.on_base.should == "your order does not meet the minimum"

    o.order_items << Factory(:expensive_order_item)
    o.valid?.should == true
  end

  it "should generate with order_items when a pickup is passed to new" do
    pickup = Factory(:pickup_with_stock_items)
    order = Order.new_from_pickup(pickup)
    pickup.stock_items.size.should_not == 0
    order.order_items.size.should_not == 0
    order.order_items.size.should == pickup.stock_items.size
  end

  it "should be able to get only order_items with quantity > 0" do
    order = Factory(:order_with_items)
    order.order_items.size.should == 2
    order.order_items.with_quantity.size.should == 1
    order.order_items.with_quantity.each do |item|
      item.quantity.should > 0
    end
  end

  it "should be able to have a finalized_total amount assigned" do
    order = Factory(:order_with_items, :finalized_total => 53.55)
    order.finalized_total.should == 53.55
  end

  it "should return total items * quantity ordered" do
    order = Factory(:order)
    order.order_items << Factory(:order_item, :order => order, :quantity => 1)
    order.order_items << Factory(:order_item, :order => order, :quantity => 3)

    order.total_items_quantity.should == 4
    order.order_items << Factory(:order_item, :order => order, :quantity => 2)
    order.total_items_quantity.should == 6

  end

end
