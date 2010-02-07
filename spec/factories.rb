require 'factory_girl'

# BASE FACTORIES

Factory.define :user do |u|
  u.first_name 'Timothy'
  u.last_name 'Riggins'
  u.sequence(:username) {|n| "DillonFootballRules#{n}"}
  u.sequence(:email_address) {|n| "qb#{n}@dillonfootball.com" }
  u.phone_number '5123533694'
  u.password 'gopanthers'
  u.password_confirmation 'gopanthers'
end

Factory.define :farm do |f|
  f.name 'Soul Food Farm'
end

Factory.define :subscription do |s|
  s.association :farm, :factory => :farm
  s.association :user, :factory => :user
end

Factory.define :pickup do |p|
  p.name 'Emeryville'
  p.association :farm, :factory => :farm
  p.date '2010-01-28'
  p.status 'closed'
  p.host 'Tami Taylor'
  p.location '38 Panther Street, Dillon, TX 59285'
  p.opening_at '2010-01-08 00:01:00'
  p.closing_at '2010-01-23 00:01:00'
end

Factory.define :order do |o|
  o.association :user
  o.association :pickup
end

Factory.define :product do |p|
  p.name 'Chicken, REGULAR'
  p.association :farm
  p.price 30
end

Factory.define :stock_item do |p|
  p.association :pickup
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
    2.times{|f| items << i.association(:order_item)}
    items
  end
end

Factory.define :cheap_order_item, :parent => :order_item do |i|
  i.stock_item {Factory(:stock_item, :product => Factory(:product, :price => 5))}
end

Factory.define :expensive_order_item, :parent => :order_item do |i|
  i.stock_item {Factory(:stock_item, :product => Factory(:product, :price => 100))}
end

