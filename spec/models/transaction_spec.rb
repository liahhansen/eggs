require 'spec_helper'

describe Transaction do
  before(:each) do
    @valid_attributes = {
      :date => Date.today,
      :amount => 1.5,
      :description => "value for description",
      :member_id => 1,
      :order_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Transaction.create!(@valid_attributes)
  end
end
