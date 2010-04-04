# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  phone_number      :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  crypted_password  :string(255)
#  password_salt     :string(255)
#  persistence_token :string(255)
#  email             :string(255)
#  member_id         :integer(4)
#  perishable_token  :string(255)
#  active            :boolean(1)      default(FALSE), not null
#

require 'spec_helper'

describe User do
  before(:each) do
    @valid_attributes = {
      :email => "dillon@example.com",
      :password => "gopanthers",
      :password_confirmation => "gopanthers",

    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end

  it "should allow updating of member and change user email/login" do
    user = Factory(:member_user)
    user.update_attributes("email"=>"ben@kathrynaaker.com", "member_attributes"=>{"address"=>"Somewhere over the rainbow...",
                                                "alternate_email"=>"",
                                                "phone_number"=>"333-444-5555",
                                                "last_name"=>"Brown",
                                                "first_name"=>"Ben"})


    user.update_member_email
    user.member.first_name.should == "Ben"
    user.member.email_address.should == "ben@kathrynaaker.com"
  end

  it "should allow for no password on initial create" do
    user = User.new
    user.email = "foo@example.com"
    user.valid?.should == true
  end

end
