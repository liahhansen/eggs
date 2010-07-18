# == Schema Information
#
# Table name: farms
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  key           :string(255)
#  paypal_link   :string(255)
#  contact_email :string(255)
#  contact_name  :string(255)
#

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

  it "should be able to store contact info and payment URL" do
    f = Factory(:farm_with_details)
    f.paypal_link.should == "http://paypal.pay.me/please"
    f.contact_email.should == "csa@example.com"
    f.contact_name.should == "Kathryn Aaker"
    f.paypal_account.should == "csa@example.com"
  end

  it "should be able to have mailinglist, deposit and referral be optional" do
    f = Factory(:farm_with_details)
    f.require_deposit.should == true
    f.require_mailinglist.should == true
    f.request_referral.should == true
  end

end
