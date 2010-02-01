class OrderItem < ActiveRecord::Base
  belongs_to :stock_item
  belongs_to :order

  validates_presence_of :stock_item_id,:quantity,:order_id
  validate :stock_item_must_exist, :order_must_exist

  def stock_item_must_exist
    errors.add(:stock_item_id, "this stock_item must exist") if stock_item_id && !StockItem.find(stock_item_id)
end

  def order_must_exist
    errors.add(:order_id, "this order must exist") if order_id && !Order.find(order_id)
  end
end
