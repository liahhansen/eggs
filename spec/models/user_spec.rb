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
