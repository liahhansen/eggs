# == Schema Information
#
# Table name: transactions
#
#  id          :integer         not null, primary key
#  date        :date
#  amount      :float
#  description :string(255)
#  member_id   :integer
#  order_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Transaction < ActiveRecord::Base
  belongs_to :subscription
  belongs_to :order

  before_create :zero_nil_amount, :calculate_balance

  def zero_nil_amount
    self.amount = 0 if self.amount == nil
  end

  def calculate_balance
    if !balance
      last = Transaction.find_all_by_subscription_id(subscription.id, :order => :date).last
      if last
        self.balance = last.balance + (debit ? -amount : amount)
      else
        self.balance = debit ? -amount : amount
      end
    end
  end

end
