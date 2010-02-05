class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :farms, :through => :subscriptions
  has_many :orders

  validates_presence_of :first_name, :last_name, :username, :email_address, :phone_number, :neighborhood, :password

  acts_as_authentic
end
