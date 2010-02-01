class Order < ActiveRecord::Base
  belongs_to :member
  belongs_to :pickup
  has_many :order_items, :dependent => :destroy

  def estimated_total
    total = 0
    order_items.each do |item|     
      total += item.stock_item.product.price * item.quantity
    end
    total
  end
  
end
