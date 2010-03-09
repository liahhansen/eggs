# == Schema Information
#
# Table name: members
#
#  id            :integer         not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  email_address :string(255)
#  phone_number  :string(255)
#  neighborhood  :string(255)
#  joined_on     :datetime
#  created_at    :datetime
#  updated_at    :datetime
#

class Member < ActiveRecord::Base
  has_many :subscriptions
  has_many :farms, :through => :subscriptions
  has_many :orders, :dependent => :destroy do
    def filter_by_farm(farm)
      self.select {|order| order.delivery.farm == farm}
    end
  end

  validates_presence_of :first_name, :last_name, :email_address, :phone_number
end
