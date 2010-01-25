class StockItem < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :product
  has_many :order_items
end
