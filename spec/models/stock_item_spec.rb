require 'spec_helper'

describe StockItem do
  before(:each) do
    @product = Factory(:product)
    @valid_attributes = {
      :product_id => @product.id,
      :pickup_id => 4
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

  it "should have product attributes after save" do
    stockitem = StockItem.create!(@valid_attributes)

    stockitem.product_description.should  == @product.description
    stockitem.product_name.should         == @product.name
    stockitem.product_price.should        == @product.price
    stockitem.product_estimated.should    == @product.estimated
  end

end
