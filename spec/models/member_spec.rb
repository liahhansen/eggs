# == Schema Information
#
# Table name: members
#
#  id            :integer         not null, primary key
#  first_name    :string(255)
#  last_name     :string(255)
#  email_address :string(255)
#  phone_number  :string(255)
#  neighborhood  :string(255)
#  joined_on     :datetime
#  created_at    :datetime
#  updated_at    :datetime
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
end
