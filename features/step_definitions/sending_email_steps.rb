Given /^there are email templates$/ do
  Factory.create(:email_template, :farm => @farm)
  Factory.create(:pickup_reminder_email_template, :name => "Order Pickup Reminder", :farm => @farm)
end