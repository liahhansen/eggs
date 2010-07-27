require "spec"
require 'spec_helper'


describe DeliveryExporter do

  it "should only export stock items with quantity" do
    delivery = Factory(:delivery)
    delivery.stock_items << Factory.create(:stock_item, :quantity_available => 1, :product_name => 'eggs', :delivery => delivery)
    delivery.stock_items << Factory.create(:stock_item, :quantity_available => 0, :product_name => 'lettuce', :delivery => delivery)

    delivery.stock_items.size.should == 2
    delivery.stock_items.with_quantity.size.should == 1

    csv = DeliveryExporter.get_csv(delivery)
    csv.include?("eggs").should == true
    csv.include?("lettuce").should == false
  end
end