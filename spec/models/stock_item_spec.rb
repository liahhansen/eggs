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
    eggs = stock_items(:feb3_eggs)
    chicken = stock_items(:feb3_chickenreg)

    eggs.sold_out?.should == true
    chicken.sold_out?.should == false
  end

end
