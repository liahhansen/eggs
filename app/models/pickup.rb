class Pickup < ActiveRecord::Base
  belongs_to :farm
  validates_presence_of :farm_id
end
