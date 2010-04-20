# == Schema Information
#
# Table name: locations
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  host_name   :string(255)
#  host_phone  :string(255)
#  host_email  :string(255)
#  address     :string(255)
#  notes       :text
#  time_window :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  farm_id     :integer(4)
#

class Location < ActiveRecord::Base
  has_many :deliveries, :through => :pickups
  belongs_to :farm
  has_many :orders

  liquid_methods :name, :host_name, :host_phone, :host_email, :address, :notes, :time_window, :map_link

  def map_link
    "http://mapof.it/#{address}"
  end

end

