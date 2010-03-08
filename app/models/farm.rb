# == Schema Information
#
# Table name: farms
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  key        :string(255)
#

class Farm < ActiveRecord::Base
  validates_presence_of :name
  has_many :products
  has_many :deliveries
  has_many :subscriptions
  has_many :members, :through => :subscriptions
  has_many :locations

  acts_as_authorization_object

  # TODO: Figure out why this relationship is broken!
  def users
    user_arr = []
    subscriptions.each do |s|
      user_arr << User.find(s.user.id)
    end
    user_arr
  end

end
