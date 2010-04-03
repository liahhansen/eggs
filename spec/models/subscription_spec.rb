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

require 'spec_helper'

describe Subscription do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Subscription.create!(@valid_attributes)
  end

  it "should return the current balance based on the last transaction" do
    subscription = Factory(:subscription)

    subscription.current_balance.should == 0

    Factory(:transaction, :amount => 100, :debit => false, :subscription => subscription)
    Factory(:transaction, :amount => 40, :debit => true, :subscription => subscription)

    subscription.current_balance.should == 60
  end
end
