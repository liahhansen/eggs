# == Schema Information
#
# Table name: transactions
#
#  id              :integer         not null, primary key
#  date            :date
#  amount          :float
#  description     :string(255)
#  member_id       :integer
#  order_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#  debit           :boolean
#  balance         :float
#  subscription_id :integer
#

require 'spec_helper'

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :date => Date.today,
      :amount => 1.5,
      :description => "value for description",
      :subscription_id => 1,
      :balance => 10,
      :debit => true
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end

  it "should calculate a new balance based on the previous" do
    sub = Factory(:subscription)
    Factory(:transaction, :subscription => sub, :amount => 100, :debit => false, :balance => 100)
    Factory(:transaction, :subscription => sub, :amount => 40, :debit => true)
    sub.current_balance.should == 60;
  end

end
