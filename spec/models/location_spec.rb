# == Schema Information
#
# Table name: locations
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  host_name   :string(255)
#  host_phone  :string(255)
#  host_email  :string(255)
#  address     :string(255)
#  notes       :text
#  time_window :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  farm_id     :integer(4)
#

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
