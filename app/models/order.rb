class Order < ActiveRecord::Base
  belongs_to :member
  belongs_to :pickup
  has_many :order_items
end
