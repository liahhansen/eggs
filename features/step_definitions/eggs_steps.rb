
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am the registered user (.+)$/ do |login|
  params = {
    "username"=> login,
    "password"=>"eggsrock",
    "password_confirmation"=>"eggsrock"
  }
  @user = User.create(params)
end

When /^I login with valid credentials$/ do
  fill_in('Username', :with => @user.username)
  fill_in('Password', :with => "eggsrock")
  click_button("Login")
end

Then /^I should be on ([^\"]*)$/ do |page_name|
  response.request.path.should == path_to(page_name)
end

Given /^I am a registered user $/ do
  UserSession.create Factory(:user)
end