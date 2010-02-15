class Member < ActiveRecord::Base
  has_many :subscriptions
  has_many :farms, :through => :subscriptions
  has_many :orders do
    def filter_by_farm(farm)
      self.select {|order| order.pickup.farm == farm}
    end
  end

  validates_presence_of :first_name, :last_name, :email_address, :phone_number
end
