class StockItem < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :product

  validates_presence_of :product_id, :pickup_id

  before_create :copy_product_attributes


  def sold_out?

    items = OrderItem.find_all_by_stock_item_id(id)

    total_ordered = 0
    items.each do |item|
      total_ordered += item.quantity
    end

    total_ordered >= quantity_available ? true : false
    
  end

  def copy_product_attributes
    self.product_name         = product.name
    self.product_description  = product.description
    self.product_price        = product.price
    self.product_estimated    = product.estimated
  end

  def quantity_ordered
    OrderItem.find_all_by_stock_item_id(id).inject(0){|total, item| total + item.quantity}
  end

  def quantity_remaining
    quantity_available - quantity_ordered
  end

end
