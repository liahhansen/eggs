require 'spec_helper'

describe RolesUser do
  before(:each) do
    @valid_attributes = {
      :role_id => 1,
      :user_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    RolesUser.create!(@valid_attributes)
  end
end
