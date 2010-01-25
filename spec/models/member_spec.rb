require 'spec_helper'

describe Member do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Member.create!(@valid_attributes)
  end
end
