class OrderForm

  attr_reader :order_items, :pickup, :errors, :notes

  def initialize(pickup)
    @order_items = []
    @pickup = pickup
    @errors = {}
    pickup.stock_items.each do |item|
      @order_items << OrderItem.new(:stock_item_id => item.id)
    end
  end

  

end