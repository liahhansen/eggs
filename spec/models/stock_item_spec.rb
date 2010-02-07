require 'spec_helper'

describe StockItem do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    StockItem.create!(@valid_attributes)
  end

  it "should return sold out status" do
    eggs = Factory(:stock_item, :quantity_available => 2)
    eggs.sold_out?.should == false

    2.times {Factory(:order_item, :stock_item => eggs)}
    eggs.sold_out?.should == true
  end

end
