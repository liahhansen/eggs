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

Factory.define :role do |r|
  r.name 'admin'
end

Factory.define :roles_user do |r|
  r.association :user
  r.association :role
end

Factory.define :farm do |f|
  f.name 'Soul Food Farm'
end

Factory.define :subscription do |s|
  s.association :farm
  s.association :user
end

Factory.define :pickup do |p|
  p.name 'Emeryville'
  p.association :farm
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
    2.times{items << i.association(:order_item)}
    items
  end
end

Factory.define :cheap_order_item, :parent => :order_item do |i|
  i.stock_item {Factory(:stock_item, :product => Factory(:product, :price => 5))}
end

Factory.define :expensive_order_item, :parent => :order_item do |i|
  i.stock_item {Factory(:stock_item, :product => Factory(:product, :price => 100))}
end

Factory.define :pickup_with_orders, :parent => :pickup do |p|
  p.orders do |o|
    arr = []
    3.times{arr << o.association(:order_with_items)}
    arr
  end
end

Factory.define :pickup_with_stock_items, :parent => :pickup do |pickup|
  pickup.after_create do |p|
    3.times {p.stock_items << Factory(:stock_item, :pickup => p)}
  end

# TODO: Figure out why association doesn't set the stock_item pickup_id to be this id automatically
#  p.stock_items do |s|
#    items = []
#    3.times{items << s.association(:stock_item)}
#    items
#  end
end

Factory.define :farm_with_members, :parent => :farm do |f|
  f.users do |u|
    members = []
    4.times{members << u.association(:user)}
    members
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