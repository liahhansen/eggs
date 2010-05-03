Given /^the member "([^\"]*)" is pending$/ do |last_name|
  member = Member.find_by_last_name(last_name)
  member.pending = true
  member.save!
end