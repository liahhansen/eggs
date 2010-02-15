require 'factory_girl'

# BASE FACTORIES

Factory.define :user do |user|
  user.sequence(:username) {|n| "DillonFootballRules#{n}"}
  user.password 'gopanthers'
  user.password_confirmation 'gopanthers'
  user.after_create do |u|
    u.member = Factory(:member)
  end
end

Factory.define :member do |m|
  m.first_name 'Timothy'
  m.last_name 'Riggins'
  m.sequence(:email_address) {|n| "qb#{n}@dillonfootball.com" }
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
end

Factory.define :subscription do |s|
  s.association :farm
  s.association :member
end

Factory.define :pickup do |p|
  p.name 'Emeryville'
  p.association :farm
  p.date '2010-01-28'
  p.status 'inprogress'
  p.host 'Tami Taylor'
  p.location '38 Panther Street, Dillon, TX 59285'
  p.opening_at '2010-01-08 00:01:00'
  p.closing_at '2010-01-23 00:01:00'
end

Factory.define :order do |o|
  o.association :member
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
end

Factory.define :farm_with_members, :parent => :farm do |farm|
  farm.after_create do |f|
    4.times do
      s = Factory(:subscription, :farm => f, :member => Factory(:member))
    end
  end
end

Factory.define :farm_with_products, :parent => :farm do |farm|
  farm.after_create do |f|
    3.times {f.products << Factory(:product, :farm => f)}
  end
end

Factory.define :farm_with_pickups, :parent => :farm do |farm|
  farm.after_create do |f|
    f.pickups << Factory(:pickup, :farm => f, :status => "inprogress")
    f.pickups << Factory(:pickup, :farm => f, :status => "inprogress")
    f.pickups << Factory(:pickup, :farm => f, :status => "open")
    f.pickups << Factory(:pickup, :farm => f, :status => "notyetopen")
    f.pickups << Factory(:pickup, :farm => f, :status => "archived")
    f.pickups << Factory(:pickup, :farm => f, :status => "finalized")
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
    pickup1 = Factory(:pickup, :farm => m.farms[0])
    pickup2 = Factory(:pickup, :farm => m.farms[1])
    order1 = Factory(:order, :pickup => pickup1, :member => m)
    order2 = Factory(:order, :pickup => pickup2, :member => m)
  end
end