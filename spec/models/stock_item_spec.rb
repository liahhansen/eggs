require 'spec_helper'

describe StockItem do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    StockItem.create!(@valid_attributes)
  end
end
