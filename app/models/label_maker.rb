class Label
  attr_accessor :label_num
  attr_accessor :total_labels
  attr_accessor :order_items
  attr_accessor :order
end

class LabelMaker
  def get_labels_from_order(order)
    labels = []

    total_label_num = (order.order_items.with_quantity.size.to_f / 6).ceil

    (1..total_label_num).each do |num|
      label = Label.new
      label.order_items = order.order_items.with_quantity[(num-1)*6...(num*6)]
      label.label_num = num
      label.total_labels = total_label_num
      label.order = order
      labels.push label
    end
    
    return labels
  end

  def get_labels_from_delivery(delivery)
    labels = []
    delivery.orders.each do |order|
      order_labels = get_labels_from_order order
      labels += order_labels
    end
    return labels
  end
end