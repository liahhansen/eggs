Given /^there is a farm "([^\"]*)"$/ do |farm_name|
  existing_farm = Farm.find_by_name(farm_name)

  if existing_farm
    @farm = existing_farm
  else
    @farm = Factory(:farm, :name => farm_name)
  end
end

Given /^the farm has a location "([^\"]*)" with host "([^\"]*)"$/ do |location_name, host_name|
  Given 'there is a farm "Soul Food Farm"'
  Factory.create(:location, :name => location_name, :host_name => host_name, :farm => @farm)
end

Given /^the farm has the member "([^\"]*)"$/ do |member_name|
  Given 'there is a farm "Soul Food Farm"'
  name = member_name.split(' ')
  member = Factory.create(:member, :first_name => name[0], :last_name => name[1])
  Factory.create(:subscription, :member => member, :farm => @farm)
end