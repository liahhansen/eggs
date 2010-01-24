class Product < ActiveRecord::Base
  belongs_to :farm

  validates_presence_of :farm_id
  validates_presence_of :name
end
