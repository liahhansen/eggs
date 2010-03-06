class OrderForm

  attr_reader :order_items, :delivery, :errors, :notes

  def initialize(delivery)
    @order_items = []
    @delivery = delivery
    @errors = {}
    delivery.stock_items.each do |item|
      @order_items << OrderItem.new(:stock_item_id => item.id)
    end
  end

  

end