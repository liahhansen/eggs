Given /^the member "([^\"]*)" is pending$/ do |last_name|
  member = Member.find_by_last_name(last_name)
  sub = member.subscription_for_farm(@farm)
  sub.pending = true
  sub.save!
end