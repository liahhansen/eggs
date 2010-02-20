# == Schema Information
#
# Table name: pickups
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  description         :text
#  farm_id             :integer
#  date                :date
#  status              :string(255)
#  host                :string(255)
#  location            :string(255)
#  opening_at          :datetime
#  closing_at          :datetime
#  notes               :text
#  created_at          :datetime
#  updated_at          :datetime
#  minimum_order_total :integer
#

require 'spec_helper'

describe Pickup do
  before(:each) do
    @valid_attributes = {
      :farm_id => Factory(:farm).id
    }
  end

  it "should create a new instance given valid attributes" do
    Pickup.create!(@valid_attributes)
  end

  it "should return an estimated total for all orders" do
    pickup = Factory(:pickup_with_orders)
    pickup.estimated_total.should == pickup.orders.inject(0){|total, o| total + o.estimated_total}
  end

  it "should have an available list of members for its related farm" do
    pickup = Factory(:pickup, :farm => Factory(:farm_with_members))
    pickup.farm.members.size.should == 4
    pickup.farm.members.each do |u|
      thisfarm = false
      u.farms.each do |f|
        thisfarm = true if f.id == pickup.farm.id
      end
      thisfarm.should == true
    end
  end

  it "should generate with stock_items when a farm is passed to new" do
    farm = Factory(:farm_with_products)
    pickup = Pickup.new_from_farm(farm)
    
    pickup.stock_items.size.should_not == 0
    farm.products.size.should_not == 0
    pickup.stock_items.size.should == farm.products.size
  end

  it "should save with stock items when they are estimated" do
    farm = Factory(:farm)
    farm.products << Factory(:product, :farm => farm)
    farm.products << Factory(:product, :farm => farm)

    pickup = Pickup.new_from_farm(farm)
    pickup.farm_id = farm.id
    pickup.stock_items[1].product_estimated = false
    pickup.valid?.should == true
    pickup.save
    pickup.stock_items.size.should == 2

    Pickup.find(pickup.id).stock_items.size.should == 2


  end

  it "should be able to take a hash and create new stock_items" do

    pickup_hash = {"closing_at(4i)"=>"17",
                   "name"=>"asdf",
                   "closing_at(5i)"=>"00",
                   "location"=>"",
                   "date(1i)"=>"2010",
                   "stock_items_attributes"=>{
                           "0"=>{"product_description"=>"1 dozen of the best eggs you'll ever eat.", "max_quantity_per_member"=>"4", "product_id"=>"114468584", "notes"=>"", "product_estimated"=>"false", "product_price"=>"6.5", "product_name"=>"Eggs", "quantity_available"=>"50"},
                           "1"=>{"product_description"=>"Large chickens come from the farm next door, also pasture-raised. Good meat/bone ratio.  ($6/lb., 4.5-5.5lbs)", "max_quantity_per_member"=>"4", "product_id"=>"337383792", "notes"=>"", "product_estimated"=>"true", "product_price"=>"33.0", "product_name"=>"Chicken, LARGE", "quantity_available"=>"50"},
                           "2"=>{"product_description"=>"($6/lb., 7-7.25 lbs)", "max_quantity_per_member"=>"4", "product_id"=>"501917461", "notes"=>"", "product_estimated"=>"true", "product_price"=>"42.0", "product_name"=>"Chicken, XXL", "quantity_available"=>"50"},
                           "3"=>{"product_description"=>"500ml", "max_quantity_per_member"=>"4", "product_id"=>"1588188741", "notes"=>"", "product_estimated"=>"false", "product_price"=>"18.0", "product_name"=>"Terra Sole olive oil", "quantity_available"=>"50"},
                           "4"=>{"product_description"=>"A medium-large, pasture-raised chicken.  ($6.50/lb., 3.75-4.5 lbs)", "max_quantity_per_member"=>"4", "product_id"=>"2026084183", "notes"=>"", "product_estimated"=>"true", "product_price"=>"26.0", "product_name"=>"Chicken, REGULAR", "quantity_available"=>"50"}}, "date(2i)"=>"2", "notes"=>"", "date(3i)"=>"16", "minimum_order_total"=>"25", "opening_at(1i)"=>"2010", "opening_at(2i)"=>"2", "opening_at(3i)"=>"16", "closing_at(1i)"=>"2010", "opening_at(4i)"=>"17", "host"=>"", "description"=>"", "farm_id"=>"1213367748", "closing_at(2i)"=>"2", "opening_at(5i)"=>"00", "status"=>"notyetopen", "closing_at(3i)"=>"16"}

    pickup = Pickup.new(pickup_hash)
    pickup.valid?.should == true

    pickup.save
    pickup.stock_items.size.should == 5

    Pickup.find(pickup.id).stock_items.size.should == 5

  end

  it "should calculate a finalized total from orders" do
    pickup = Factory(:pickup_with_orders)
    pickup.finalized_total.should == 0

    pickup.orders.each {|order| order.finalized_total = 10 }
    pickup.finalized_total.should == 10 * pickup.orders.size
  end

end
