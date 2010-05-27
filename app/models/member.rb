# == Schema Information
#
# Table name: members
#
#  id              :integer(4)      not null, primary key
#  first_name      :string(255)
#  last_name       :string(255)
#  email_address   :string(255)
#  phone_number    :string(255)
#  neighborhood    :string(255)
#  joined_on       :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  address         :string(255)
#  alternate_email :string(255)
#  notes           :text
#

class Member < ActiveRecord::Base
  has_many :subscriptions
  has_many :farms, :through => :subscriptions
  has_many :orders, :dependent => :destroy, :include => :delivery, :order => 'deliveries.date DESC' do
    def filter_by_farm(farm)
      self.select {|order| order.delivery.farm == farm}
    end
  end

  has_one :user

  validates_presence_of :first_name, :last_name, :email_address, :phone_number
  validates_uniqueness_of :email_address

  liquid_methods :first_name, :last_name, :email_address, :address, :phone_number, :alternate_email,
                 :balance_for_farm, :referral, :deposit_type, :deposit_received, :joined_mailing_list

  def after_create
    self.update_attribute(:joined_on, Date.today) if !joined_on
  end

  def email_address_with_name
    "\"#{first_name} #{last_name}\" <#{email_address}>"
  end

  def balance_for_farm(farm)
    subscription = subscription_for_farm(farm)
    subscription.current_balance
  end

  def subscription_for_farm(farm)
    subscriptions.detect{|subscription|subscription.farm_id == farm.id}
  end
  
end
