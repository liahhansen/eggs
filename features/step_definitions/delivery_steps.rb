
Given /^the member "([^\"]*)" has an order for the delivery "([^\"]*)" and the location "([^\"]*)"$/ do |member_last_name, delivery_name, location_name|
  delivery = Delivery.find_by_name(delivery_name)

  order = Order.new_from_delivery(delivery)
  order.member = Member.find_by_last_name(member_last_name)
  order.location = delivery.locations.detect{|l| l.name == location_name}

  order.order_items.each {|item| item.quantity = 1}

  delivery.orders << order
  delivery.save!
end

Given /^the farm has a product called "([^\"]*)"$/ do |product_name|
  @farm.products << Factory.create(:product, :name => product_name, :farm => @farm)
end

Given /^the delivery "([^\"]*)" has the stock_item "([^\"]*)" with a price of (.+)$/ do |delivery_name, stock_item_name, price|
  Given 'there is a farm'
  Given 'the farm has a product called "'+stock_item_name+'"'
  delivery = Delivery.find_by_name(delivery_name)

  delivery.stock_items << StockItem.new(:product_name => stock_item_name, :product_estimated => price, :product => Product.find_by_name(stock_item_name))
  delivery.save!

end

Given /^the delivery has a minimum total of (.+)$/ do |minimum_total|
  @delivery.minimum_order_total = minimum_total
  @delivery.save!
end

Given /^there is a "([^\"]*)" delivery "([^\"]*)"$/ do |status, delivery_name|
  steps %Q{
    Given there is a farm
    Given the farm has the member "Ben Brown"
    Given the farm has the member "Suzy Smith"
    Given the farm has the member "Alice Anderson"
    Given the farm has a location "Hayes Valley" with host "Billy Baggins"
    Given the farm has a location "Farm" with host "Suzanne Smith"
  }

  @delivery = Factory.create(:delivery, :name => delivery_name, :status => status, :farm => @farm)
  @delivery.locations << Location.find_by_name("Hayes Valley")
  @delivery.save!

  steps %Q{
    Given the delivery "#{delivery_name}" has the stock_item "Chicken, REGULAR" with a price of 30
    Given the delivery "#{delivery_name}" has the stock_item "Chicken, EXTRA LARGE" with a price of 45
    Given the delivery "#{delivery_name}" has the stock_item "Eggs" with a price of 6.5
    Given the member "Brown" has an order for the delivery "#{delivery_name}" and the location "Hayes Valley"
    Given the member "Smith" has an order for the delivery "#{delivery_name}" and the location "Hayes Valley"
    Given the member "Anderson" has an order for the delivery "#{delivery_name}" and the location "Hayes Valley"
  }
end

Given /^the "([^\"]*)" delivery has a date of "([^\"]*)"$/ do |delivery_name, delivery_date|
  delivery = Delivery.find_by_name(delivery_name)
  delivery.date = delivery_date
  delivery.save!
end

Given /^I have an existing order for the "([^\"]*)" delivery$/ do |name|
  steps %Q{
    Given the member "#{@user.member.last_name}" has an order for the delivery "#{name}" and the location "Hayes Valley"
  }
end