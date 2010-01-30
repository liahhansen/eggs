require 'spec_helper'

describe Order do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end

  it "should return an estimated order total" do
    order= orders(:kathryn_sf_emeryville_feb3)

    order.estimated_total.should == 91
    
  end
end
