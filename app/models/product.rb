class Product < ActiveRecord::Base
  belongs_to :farm
  has_many :stock_items

  validates_presence_of :farm_id
  validates_presence_of :name
end
