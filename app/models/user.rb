class User < ActiveRecord::Base
  belongs_to :member
  has_many :roles_users
  has_many :roles, :through => :roles_users

  validates_presence_of :password, :username

  acts_as_authorization_subject
  acts_as_authentic
end
