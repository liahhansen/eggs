class Location < ActiveRecord::Base
  has_many :deliveries, :through => :pickups
  belongs_to :farm
end
