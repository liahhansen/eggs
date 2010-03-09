# == Schema Information
#
# Table name: pickups
#
#  id          :integer         not null, primary key
#  delivery_id :integer
#  location_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Pickup < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :location
end
