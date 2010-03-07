class Location < ActiveRecord::Base
  has_many :deliveries, :through => :pickups
end
