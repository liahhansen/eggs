require 'spec_helper'

describe OrderItem do
  before(:each) do
    @valid_attributes = {
      :stock_item_id => Factory(:stock_item).id,
      :order_id => Factory(:order).id,
      :quantity => 2
    }
  end

  it "should create a new instance given valid attributes" do
    OrderItem.create!(@valid_attributes)
  end

  it "should not be valid unless it has valid stock_item_id and quantity" do
    lambda {OrderItem.new(:stock_item_id => 2353135, :order_id => 125125).valid?}.should raise_error
    OrderItem.new(:stock_item_id => Factory(:stock_item).id, :order_id => Factory(:order).id,:quantity=>1).valid?.should == true
  end

  it "should have a quantity of 0 to 99" do
    OrderItem.new(:stock_item_id => Factory(:stock_item).id, :order_id => Factory(:order).id,:quantity=>100).valid?.should == false
    OrderItem.new(:stock_item_id => Factory(:stock_item).id, :order_id => Factory(:order).id,:quantity=>1).valid?.should == true
  end

  it "should throw error if sold out on create" do
    stock_item = Factory(:stock_item, :quantity_available => 4)
    Factory(:order_item, :stock_item => stock_item, :quantity => 3)
    stock_item.sold_out?.should == false

    Factory(:order_item, :stock_item => stock_item, :quantity => 1)
    stock_item.sold_out?.should == true

    order_item = Factory.build(:order_item, :stock_item => stock_item, :quantity => 1)
    order_item.valid?.should == false
    order_item.errors.on("quantity").downcase.should include "sold out"
  end

  it "should allow you to update an order_item with your last quantity regardless of inventory" do
    stock_item = Factory(:stock_item, :quantity_available => 4)
    order_item = Factory(:order_item, :stock_item => stock_item, :quantity => 4)

    order_item.quantity = 4
    order_item.valid?.should == true
    order_item.quantity = 5
    order_item.valid?.should == false

  end

end
