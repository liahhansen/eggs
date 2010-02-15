# == Schema Information
#
# Table name: stock_items
#
#  id                      :integer         not null, primary key
#  pickup_id               :integer
#  product_id              :integer
#  max_quantity_per_member :integer
#  quantity_available      :integer
#  substitutions_available :boolean
#  notes                   :text
#  created_at              :datetime
#  updated_at              :datetime
#  hide                    :boolean
#  product_name            :string(255)
#  product_description     :text
#  product_price           :float
#  product_estimated       :boolean
#

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
    stock_item = StockItem.create!(@valid_attributes)

    stock_item.product_description.should  == @product.description
    stock_item.product_name.should         == @product.name
    stock_item.product_price.should        == @product.price
    stock_item.product_estimated.should    == @product.estimated
  end

  it "should return quantity ordered" do
    stock_item = Factory(:stock_item, :quantity_available => 10)
    Factory(:order_item, :stock_item => stock_item, :quantity => 4)

    stock_item.quantity_ordered.should == 4
    stock_item.quantity_remaining.should == 6

  end

end
