class OrderItem < ActiveRecord::Base
  belongs_to :stock_item
  belongs_to :order
end
