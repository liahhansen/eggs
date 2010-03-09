# == Schema Information
#
# Table name: pickups
#
#  id          :integer         not null, primary key
#  delivery_id :integer
#  location_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Pickup do
  before(:each) do
    @valid_attributes = {
      :location_id => 1,
      :delivery_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Pickup.create!(@valid_attributes)
  end
end
