class Role < ActiveRecord::Base
  has_many :users, :through => :roles_users
  acts_as_authorization_role
end
