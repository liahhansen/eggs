class StockItem < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :product
end
