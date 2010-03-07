require 'spec_helper'

describe Location do
  before(:each) do
    @valid_attributes = {
      :name => "SF / Potrero",
      :host_name => "Kathryn Aaker",
      :host_phone => "123-345-1383",
      :host_email => "kathryn@kathrynaaker.com",
      :address => "123 2rd Street, San Francisco, CA 94110",
      :notes => "Entry is through the side garage door",
      :time_window => "5-7pm"
    }
  end

  it "should create a new instance given valid attributes" do
    Location.create!(@valid_attributes)
  end
end
