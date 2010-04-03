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

require 'spec_helper'

describe Member do
  before(:each) do
    @valid_attributes = {
      :first_name => "Timothy",
      :last_name => "Riggins",
      :email_address => "tim@riggins.net",
      :phone_number => "512-353-3694",
      :neighborhood => "dillon"
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end

  it "should return only the orders for a specific farm" do
    member = Factory(:member_with_orders_from_2_farms)
    member.orders.size.should == 2
    member.orders.filter_by_farm(member.farms.first).size.should == 1
  end

  it "can return the balance for a subscription given a farm" do
    farm = Factory(:farm_with_members)
    member = farm.members.first
    member.subscriptions.size.should == 1

    transaction = Transaction.new(:member_id => member.id, :subscription => member.subscriptions.first,
                    :amount => 90, :debit => true)
    
    transaction.save.should == true
    member.subscriptions.first.current_balance.should == -90
    member.balance_for_farm(farm).should == -90

  end
end
