# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer(4)      not null, primary key
#  member_id  :integer(4)
#  farm_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Subscription < ActiveRecord::Base
  belongs_to :farm
  belongs_to :member
  has_many :transactions

  def after_create
    self.pending = true
    self.deposit_received = false
    self.joined_mailing_list = false
    self.save!
  end

  def current_balance
    last_transaction = self.transactions.last
    last_transaction ? last_transaction.balance : 0
  end

end
