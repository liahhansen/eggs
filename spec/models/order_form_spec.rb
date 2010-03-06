require 'spec_helper'

describe OrderForm do

  it "should have order items for all stock items" do
    delivery = Factory(:delivery_with_stock_items)
    order_form = OrderForm.new(delivery)

    order_form.delivery.should == delivery
    order_form.order_items.size.should == delivery.stock_items.size
  end

end