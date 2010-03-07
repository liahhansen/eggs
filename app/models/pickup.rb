class Pickup < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :location
end
