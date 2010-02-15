# == Schema Information
#
# Table name: users
#
#  id                :integer         not null, primary key
#  phone_number      :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  username          :string(255)
#  member_id         :integer
#

require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :username => "DillonFootballRules",
      :password => "gopanthers",
      :password_confirmation => "gopanthers",

    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

end
