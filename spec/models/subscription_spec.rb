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
end
