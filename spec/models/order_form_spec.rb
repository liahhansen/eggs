require 'spec_helper'

describe OrderForm do

  it "should have order items for all stock items" do
    pickup = Factory(:pickup_with_stock_items)
    order_form = OrderForm.new(pickup)

    order_form.pickup.should == pickup
    order_form.order_items.size.should == pickup.stock_items.size
  end

end