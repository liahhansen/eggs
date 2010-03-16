require 'spec_helper'

describe LabelMaker do
  def get_order_with_order_items(num_order_items, delivery = Factory(:delivery))
    order = Factory(:order, :delivery => delivery)
    num_order_items.times do
      Factory(:order_item, :order => order, :quantity => 2)
    end
    Factory(:order_item, :order => order, :quantity => 0)
    order
  end


  it "should create a label data object for a small order" do
    order = get_order_with_order_items(4)

    label_maker = LabelMaker.new
    labels = label_maker.get_labels_from_order order
    labels.size.should == 1
    labels.first.label_num.should == 1
    labels.first.total_labels.should == 1
    labels.first.order_items.size.should == 4

  end

  it "should split labels every 6 items in an order" do
    order = get_order_with_order_items(14)

    label_maker = LabelMaker.new
    labels = label_maker.get_labels_from_order order
    labels.size.should == 3
    labels.first.label_num.should == 1
    labels.first.total_labels.should == 3
    labels.last.label_num.should == 3
    labels.last.total_labels.should == 3
    labels.first.order.should == order
    labels.first.order_items.size.should == 6
    labels.last.order_items.size.should == 2
  end

  it "should create labels for all orders in a delivery" do
    delivery = Factory(:delivery)
    delivery.orders << get_order_with_order_items(4, delivery)
    delivery.orders << get_order_with_order_items(10, delivery)


    label_maker = LabelMaker.new
    labels = label_maker.get_labels_from_delivery delivery
    labels.size.should == 3
    
  end

end