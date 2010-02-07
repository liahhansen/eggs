class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :farms, :through => :subscriptions
  has_many :orders
  has_many :roles, :through => :roles_users

  validates_presence_of :first_name, :last_name, :username, :email_address, :phone_number, :password

  acts_as_authorization_subject
  acts_as_authentic
end
