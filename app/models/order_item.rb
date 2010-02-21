# == Schema Information
#
# Table name: order_items
#
#  id            :integer         not null, primary key
#  stock_item_id :integer
#  order_id      :integer
#  quantity      :integer
#  notes         :text
#  created_at    :datetime
#  updated_at    :datetime
#

class OrderItem < ActiveRecord::Base
  belongs_to :stock_item
  belongs_to :order

  named_scope :with_quantity, :conditions => ['quantity > 0']

  validates_presence_of :stock_item_id,:quantity
  validates_inclusion_of :quantity, :in => 0..99
  validate :stock_item_must_exist, :stock_item_must_not_be_sold_out

  def stock_item_must_exist
    errors.add(:stock_item_id, "this stock_item must exist") if stock_item_id && !StockItem.find(stock_item_id)
  end

  def stock_item_must_not_be_sold_out
    last_quantity = new_record? ? 0 : OrderItem.find(self.id).quantity
    if stock_item.quantity_remaining - quantity + last_quantity < 0
      errors.add(:quantity, "#{stock_item.product_name} is sold out or you have attempted to order more than are currently available.  Please check the current inventory and try again.")
    end
  end

end
