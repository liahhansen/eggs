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

  it "accepts fields pertaining to new membership" do
    subscription = Factory.build(:subscription)
    subscription.deposit_type = "paypal"
    subscription.deposit_received = false
    subscription.joined_mailing_list = false
    subscription.referral = "kathryn aaker"
    subscription.save!
    subscription.pending.should == true
  end

  it "defaults new member fields to pending" do
    subscription = Factory.build(:subscription)
    subscription.pending.should == false
    subscription.deposit_received.should == true
    subscription.joined_mailing_list.should == true
    subscription.save!

    # this is because the database defaults to not pending,
    # but newly created members default to pending = true
    subscription.pending.should == true
    subscription.joined_mailing_list.should == false
    subscription.deposit_received.should == false
  end


end
