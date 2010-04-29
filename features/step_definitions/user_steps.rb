Given /^I am the registered admin user (.+)$/ do |login|
  params = {
    "email"=> login,
    "password"=>"eggsrock",
    "password_confirmation"=>"eggsrock"
  }
  @user = User.create!(params)
  @user.has_role!(:admin)
  @user.active = true
  @user.save!
end


Given /^I am the registered member user (.+)$/ do |login|
  params = {
    "email"=> login,
    "password"=>"eggsrock",
    "password_confirmation"=>"eggsrock"
  }
  @user = User.create!(params)
  @user.has_role!(:member)
  @user.active = true
  @user.member = Factory(:member, :email_address => login)
  @user.member.farms << @farm
  @user.save!
end

When /^I login with valid credentials$/ do
  fill_in('user_session_email', :with => @user.email)
  fill_in('user_session_password', :with => "eggsrock")
  click_button("Login")
end

Given /^I am logged in as an admin$/ do
  Given "I am the registered admin user jennyjones@kathrynaaker.com"
  And "I am on login"
  Given "I login with valid credentials"
end
