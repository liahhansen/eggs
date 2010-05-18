Given /^the member "([^\"]*)" is pending$/ do |last_name|
  member = Member.find_by_last_name(last_name)
  sub = member.subscription_for_farm(@farm)
  sub.pending = true
  sub.save!
end

Given /^the member "([^\"]*)" has the email address "([^\"]*)"$/ do |name, email|
  last_name = name.split(" ").last
  member = Member.find_by_last_name(last_name)
  user = User.find_by_member_id(member.id)
  user.email = email

  user.save!
end