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
    Factory(:transaction, :amount => 100, :debit => false, :subscription => subscription)
    Factory(:transaction, :amount => 40, :debit => true, :subscription => subscription)

    subscription.current_balance.should == 60
  end
end
