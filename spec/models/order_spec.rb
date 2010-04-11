# == Schema Information
#
# Table name: orders
#
#  id              :integer(4)      not null, primary key
#  member_id       :integer(4)
#  delivery_id     :integer(4)
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  finalized_total :float
#  location_id     :integer(4)
#

require 'spec'
require 'spec_helper'

describe Order do
  before(:each) do
    @valid_attributes = {
      :member_id => Factory(:member).id,
      :delivery_id => Factory(:delivery).id,
      :order_items => Factory(:order_with_items).order_items,
      :location_id => Factory(:location).id
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end

  it "should raise errors when saving when no member or delivery is specified" do
    Order.new.valid?.should == false
    lambda {Order.create!}.should raise_error
    lambda {Order.create!(:member_id => 1)}.should raise_error
    lambda {Order.create!(:delivery_id => 2)}.should raise_error
  end

  it "should only accept valid member and delivery ids" do
    lambda {Order.new(:member_id => 235, :delivery_id => 235).valid?}.should raise_error
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

  it "should not be valid unless the order total is greater than the delivery minimum" do
    delivery = Factory(:delivery, :minimum_order_total => 25)
    order = Factory.build(:order, :delivery => Factory(:delivery, :minimum_order_total => 25))
    order.order_items << Factory(:cheap_order_item)
    order.valid?.should == false
    order.errors.on_base.should == "your order does not meet the minimum"

    order.order_items << Factory(:expensive_order_item)
    order.valid?.should == true
  end

  it "should generate with order_items when a delivery is passed to new" do
    delivery = Factory(:delivery_with_stock_items)
    order = Order.new_from_delivery(delivery)
    delivery.stock_items.size.should_not == 0
    order.order_items.size.should_not == 0
    order.order_items.size.should == delivery.stock_items.size
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
