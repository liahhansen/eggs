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

  validates_presence_of :password, :on => :create
  validates_presence_of :email

  acts_as_authorization_subject
  acts_as_authentic

  attr_accessible :email, :password, :password_confirmation

  def active?
    active
  end

  def activate!
    self.active = true
    save
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end


end
