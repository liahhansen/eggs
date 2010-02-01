class OrderItem < ActiveRecord::Base
  belongs_to :stock_item
  belongs_to :order

  validates_presence_of :stock_item_id,:quantity
  validates_inclusion_of :quantity, :in => 1..99
  validate :stock_item_must_exist

  def stock_item_must_exist
    errors.add(:stock_item_id, "this stock_item must exist") if stock_item_id && !StockItem.find(stock_item_id)
  end

end
