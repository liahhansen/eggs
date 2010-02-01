require 'spec_helper'

describe OrderItem do
  before(:each) do
    @k_order = orders(:kathryn_sf_emeryville_feb3)
    @s_item = stock_items(:feb3_chickenreg)
    @valid_attributes = {
      :stock_item_id => @s_item.id,
      :order_id => @k_order.id,
      :quantity => 2
    }
  end

  it "should create a new instance given valid attributes" do
    OrderItem.create!(@valid_attributes)
  end

  it "should not be valid unless it has valid order_id, stock_item_id and quantity" do    
    lambda {OrderItem.new(:stock_item_id => 2353135, :order_id => 125125).valid?}.should raise_error
    OrderItem.new(:stock_item_id => @s_item.id, :order_id => @k_order.id,:quantity=>1).valid?.should == true
  end

  it "should not have a quantity of zero" do
    OrderItem.new(:stock_item_id => @s_item.id, :order_id => @k_order.id,:quantity=>0).valid?.should == false
    OrderItem.new(:stock_item_id => @s_item.id, :order_id => @k_order.id,:quantity=>1).valid?.should == true
  end

end
