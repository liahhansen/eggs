class Member < ActiveRecord::Base
  has_many :subscriptions
  has_many :farms, :through => :subscriptions
end
