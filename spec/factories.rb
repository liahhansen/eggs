require 'factory_girl'

# BASE FACTORIES

Factory.define :user do |user|
  user.sequence(:email) {|n| "fan@DillonFootballRules#{n}.com"}
  user.password 'gopanthers'
  user.password_confirmation 'gopanthers'
  user.active true
  user.association :member
end

Factory.define :member do |m|
  m.first_name 'Timothy'
  m.last_name 'Riggins'
  m.sequence(:email_address) {|n| "qb#{n}@example.com" }
  m.phone_number '5123533694'
end

Factory.define :role do |r|
  r.name 'admin'
end

Factory.define :roles_user do |r|
  r.association :user
  r.association :role
end

Factory.define :farm do |f|
  f.name 'Soul Food Farm'
  f.sequence(:paypal_account) {|n| "testfarm#{n}@example.com" }
end

Factory.define :subscription do |s|
  s.association :farm
  s.association :member
end

Factory.define :location do |location|
  location.name "SF / Potrero"
  location.host_name "Kathryn Aaker"
  location.address "123 4th street"
  location.time_window "5-7pm"
  location.host_phone "123-234-5959"
  location.host_email "kathryn@example.com"
  location.association :farm
end

Factory.define :delivery do |p|
  p.name 'Emeryville'
  p.association :farm
  p.date '2010-01-27'
  p.status 'inprogress'
  p.opening_at '2010-01-08 00:01:00'
  p.closing_at '2010-01-23 00:01:00'
end

Factory.define :order do |o|
  o.association :member
  o.association :delivery
  o.association :location
end

Factory.define :product do |p|
  p.name 'Chicken, REGULAR'
  p.association :farm
  p.price 30
end

Factory.define :stock_item do |p|
  p.association :delivery
  p.association :product
end

Factory.define :order_item do |p|
  p.association :stock_item
  p.association :order
  p.quantity 1
end


Factory.define :order_with_items, :parent => :order do |o|
  o.order_items do |i|
    items = []
    items << i.association(:order_item, :quantity => 2)
    items << i.association(:order_item, :quantity => 0)
    items
  end
end

Factory.define :cheap_order_item, :parent => :order_item do |i|
  i.stock_item {Factory(:stock_item, :product => Factory(:product, :price => 5))}
end

Factory.define :expensive_order_item, :parent => :order_item do |i|
  i.stock_item {Factory(:stock_item, :product => Factory(:product, :price => 100))}
end

Factory.define :delivery_with_orders, :parent => :delivery do |p|
  p.orders do |o|
    arr = []
    3.times{arr << o.association(:order_with_items)}
    arr
  end
end

Factory.define :delivery_with_stock_items, :parent => :delivery do |delivery|
  delivery.after_create do |p|
    p.stock_items << Factory(:stock_item, :delivery => p)
    p.stock_items << Factory(:stock_item, :delivery => p)
    p.stock_items << Factory(:stock_item, :delivery => p)
  end
end

Factory.define :farm_with_members, :parent => :farm do |farm|
  farm.after_create do |f|
    4.times do
      s = Factory(:subscription, :farm => f, :member => Factory(:member))
    end
  end
end

Factory.define :farm_with_details, :parent => :farm do |farm|
  farm.paypal_link "http://paypal.pay.me/please"
  farm.contact_email "csa@example.com"
  farm.contact_name "Kathryn Aaker"
  farm.paypal_account "csa@example.com"
end

Factory.define :farm_with_products, :parent => :farm do |farm|
  farm.after_create do |f|
    3.times {f.products << Factory(:product, :farm => f)}
  end
end

Factory.define :farm_with_deliveries, :parent => :farm do |farm|
  farm.after_create do |f|
    f.deliveries << Factory(:delivery, :farm => f, :status => "inprogress")
    f.deliveries << Factory(:delivery, :farm => f, :status => "inprogress")
    f.deliveries << Factory(:delivery, :farm => f, :status => "open")
    f.deliveries << Factory(:delivery, :farm => f, :status => "notyetopen")
    f.deliveries << Factory(:delivery, :farm => f, :status => "archived")
    f.deliveries << Factory(:delivery, :farm => f, :status => "finalized")
  end
end

Factory.define :admin_user, :parent => :user do |user|
  user.after_create do |u|
      Factory(:roles_user, :role => Factory(:role, :name => 'admin'), :user => u)
  end
end

Factory.define :member_user, :parent => :user do |user|
  user.after_create do |u|
    Factory(:roles_user, :role => Factory(:role, :name => 'member'), :user => u)
  end
end

Factory.define :member_with_orders_from_2_farms, :parent => :member do |member|
  member.after_create do |m|
    m.farms << Factory(:farm)
    m.farms << Factory(:farm)
    delivery1 = Factory(:delivery, :farm => m.farms[0])
    delivery2 = Factory(:delivery, :farm => m.farms[1])
    order1 = Factory(:order, :delivery => delivery1, :member => m)
    order2 = Factory(:order, :delivery => delivery2, :member => m)
  end
end

Factory.define :transaction do |transaction|
  transaction.amount 24.50
  transaction.debit false
  transaction.association :subscription
end

Factory.define :snippet do |snippet|
  snippet.body '<h3>Welcome</h3><p>Thanks for joining us!</p>'
  snippet.identifier 'member_welcome'
  snippet.title 'Member Welcome'
end

Factory.define :email_template do |email_template|
  email_template.name "Welcome Email"
  email_template.identifier "welcome_email"
  email_template.subject "Hello"
  email_template.from "fromme@example.com"
  email_template.body "Welcome to the Farm!"
end

Factory.define :pickup_reminder_email_template, :parent => :email_template do |email_template|
  email_template.name "Pickup Reminder"
  email_template.identifier "order_pickup_reminder"
  email_template.subject "Pickup Reminder for {{order.delivery.name}} - {{order.delivery.date}}"
  email_template.from "eggs@example.com"
  email_template.body "A reminder that your pickup in {{order.location.name}} is tomorrow."
end