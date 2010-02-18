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
  belongs_to :member
  belongs_to :farm
  belongs_to :order
end
