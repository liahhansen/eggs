class StockItem < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :product
  has_many :order_items


  def sold_out?

    items = OrderItem.find_all_by_stock_item_id(id)

    total_ordered = 0
    items.each do |item|
      total_ordered += item.quantity
    end

    total_ordered >= quantity_available ? true : false
    
  end
end
