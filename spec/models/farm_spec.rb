require 'spec'
require 'spec_helper'

describe Farm do
  before(:each) do
    @valid_attributes = {
      :name => "Soul Food Farm"
    }
  end

  it "should create a new instance given valid attributes" do
    Farm.create!(@valid_attributes)
  end

  it "should not allow saving of a new instance without name" do
    f = Farm.new
    f.valid?.should == false
  end

  it "should have a list of users for that farm" do
    f = Factory(:farm_with_members)
    f.members.length.should >= 1
  end
end
