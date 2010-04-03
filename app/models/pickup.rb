# == Schema Information
#
# Table name: pickups
#
#  id          :integer(4)      not null, primary key
#  delivery_id :integer(4)
#  location_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Pickup < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :location
end
