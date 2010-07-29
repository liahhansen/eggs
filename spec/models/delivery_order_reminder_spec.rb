require 'spec_helper'

describe DeliveryOrderReminder do
  before(:each) do

    @farm = Factory(:farm_with_members)
    @valid_attributes = {
      :email_template_id => Factory(:email_template).id,
      :delivery_id => Factory(:delivery, :farm => Factory(:farm_with_members)).id,
      :delivered => false,
      :deliver_at => Time.now
    }

  end

  it "should create a new instance given valid attributes" do
    DeliveryOrderReminder.create!(@valid_attributes)
  end

end
