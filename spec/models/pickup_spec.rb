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
