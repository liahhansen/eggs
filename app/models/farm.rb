class Farm < ActiveRecord::Base
  validates_presence_of :name
  has_many :products
  has_many :pickups
end
