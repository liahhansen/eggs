require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :first_name => "Timothy",
      :last_name => "Riggins",
      :username => "DillonFootballRules",
      :email_address => "tim@riggins.net",
      :phone_number => "512-353-3694",
      :password => "gopanthers",
      :password_confirmation => "gopanthers",
      :neighborhood => "dillon"
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
end
