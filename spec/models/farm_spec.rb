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
end
