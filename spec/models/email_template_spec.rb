require 'spec_helper'

describe EmailTemplate do
  before(:each) do
    @valid_attributes = {
      :name => "Welcome Email",
      :subject => "Welcome to Soul Food Farm",
      :from => "email@example.com",
      :bcc => "another@example.com",
      :cc => "yetanother@example.com",
      :body => "Thanks for joining us, {{user.member.first_name}}"
    }
  end

  it "should create a new instance given valid attributes" do
    EmailTemplate.create!(@valid_attributes)
  end
end
