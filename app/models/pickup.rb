class Pickup < ActiveRecord::Base
  belongs_to :farm
  has_many :pickups
  has_many :stock_items
  has_many :products, :through => :stock_items

  validates_presence_of :farm_id
end
