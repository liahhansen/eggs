class Farm < ActiveRecord::Base
  validates_presence_of :name
  has_many :products
  has_many :pickups
  has_many :subscriptions
  has_many :users, :through => :subscriptions

  acts_as_authorization_object

end
