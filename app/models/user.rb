# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  phone_number      :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  username          :string(255)
#  member_id         :integer
#

class User < ActiveRecord::Base
  belongs_to :member
  has_many :roles_users
  has_many :roles, :through => :roles_users

  validates_presence_of :password, :email

  acts_as_authorization_subject
  acts_as_authentic
end
