# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  first_name        :string(255)
#  last_name         :string(255)
#  email_address     :string(255)
#  phone_number      :string(255)
#  neighborhood      :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  username          :string(255)
#

class User < ActiveRecord::Base
  has_many :subscriptions
  has_many :farms, :through => :subscriptions
  has_many :orders do
    def filter_by_farm(farm)
      self.select {|order| order.pickup.farm == farm}
    end
  end
  has_many :roles_users
  has_many :roles, :through => :roles_users

  validates_presence_of :first_name, :last_name, :username, :email_address, :phone_number, :password

  acts_as_authorization_subject
  acts_as_authentic
end
