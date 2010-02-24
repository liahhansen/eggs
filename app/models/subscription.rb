# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer         not null, primary key
#  member_id  :integer
#  farm_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Subscription < ActiveRecord::Base
  belongs_to :farm
  belongs_to :member

  def current_balance
    last_transaction = Transaction.find_all_by_subscription_id(id, :order => 'date').last
    last_transaction ? last_transaction.balance : 0
  end

end
