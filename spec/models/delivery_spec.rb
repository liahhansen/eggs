# == Schema Information
#
# Table name: deliveries
#
#  id                  :integer(4)      not null, primary key
#  name                :string(255)
#  description         :text
#  farm_id             :integer(4)
#  date                :date
#  status              :string(255)
#  opening_at          :datetime
#  closing_at          :datetime
#  notes               :text
#  created_at          :datetime
#  updated_at          :datetime
#  minimum_order_total :integer(4)
#

require 'spec_helper'

describe Delivery do
  before(:each) do
    @valid_attributes = {
      :farm_id => Factory(:farm).id,
      :date => '2010-01-28'
    }
  end

  it "should create a new instance given valid attributes" do
    Delivery.create!(@valid_attributes)
  end

  it "should return an estimated total for all orders" do
    delivery = Factory(:delivery_with_orders)
    delivery.estimated_total.should == delivery.orders.inject(0){|total, o| total + o.estimated_total}
  end

  it "should be able to deduct finalized order prices from member balances" do
    delivery = Factory(:delivery_with_orders)
    delivery.orders.each do |order|
      subscription = Factory.create(:subscription, :farm => delivery.farm, :member => order.member)
    end

    delivery.deductions_complete.should == false
    member = delivery.orders.first.member
    delivery.orders.first.finalized_total = 24.5

    # set initial balance
    Transaction.create!(:subscription_id => member.subscriptions.first, :amount => 100, :debit => false, :date => Date.today)
    
    member.balance_for_farm(delivery.farm).should == 100
    delivery.perform_deductions!.should == true
    member.balance_for_farm(delivery.farm).should == 75.5


    # check that it won't happen again
    delivery.deductions_complete.should == true
    delivery.perform_deductions!.should == false
    member.balance_for_farm(delivery.farm).should == 75.5
    

  end

  it "should have an available list of members for its related farm" do
    delivery = Factory(:delivery, :farm => Factory(:farm_with_members))
    delivery.farm.members.size.should == 4
    delivery.farm.members.each do |u|
      thisfarm = false
      u.farms.each do |f|
        thisfarm = true if f.id == delivery.farm.id
      end
      thisfarm.should == true
    end
  end

  it "should generate with stock_items when a farm is passed to new" do
    farm = Factory(:farm_with_products)
    delivery = Delivery.new_from_farm(farm)
    
    delivery.stock_items.size.should_not == 0
    farm.products.size.should_not == 0
    delivery.stock_items.size.should == farm.products.size
  end

  it "should save with stock items when they are estimated" do
    farm = Factory(:farm)
    farm.products << Factory(:product, :farm => farm)
    farm.products << Factory(:product, :farm => farm)

    delivery = Delivery.new_from_farm(farm)
    delivery.farm_id = farm.id
    delivery.stock_items[1].product_estimated = false
    delivery.date = "5/2/2008"
    delivery.valid?.should == true
    delivery.save
    delivery.stock_items.size.should == 2

    Delivery.find(delivery.id).stock_items.size.should == 2


  end

  it "should be able to take a hash and create new stock_items" do

    delivery_hash = {"closing_at(4i)"=>"17",
                   "name"=>"asdf",
                   "closing_at(5i)"=>"00", "closing_at(1i)"=>"2010", "closing_at(2i)"=>"2", "closing_at(3i)"=>"16",
                   "date"=>"03/17/2010",
                   "notes"=>"",
                   "minimum_order_total"=>"25",
                   "opening_at(1i)"=>"2010","opening_at(2i)"=>"2", "opening_at(3i)"=>"16", "opening_at(4i)"=>"17",
                   "farm_id"=>"1213367748",
                   "opening_at(5i)"=>"00", "status"=>"notyetopen",
                   "stock_items_attributes"=>{
                           "0"=>{"product_description"=>"1 dozen of the best eggs you'll ever eat.", "max_quantity_per_member"=>"4", "product_id"=>"114468584", "notes"=>"", "product_estimated"=>"false", "product_price"=>"6.5", "product_name"=>"Eggs", "quantity_available"=>"50"},
                           "1"=>{"product_description"=>"Large chickens come from the farm next door, also pasture-raised. Good meat/bone ratio.  ($6/lb., 4.5-5.5lbs)", "max_quantity_per_member"=>"4", "product_id"=>"337383792", "notes"=>"", "product_estimated"=>"true", "product_price"=>"33.0", "product_name"=>"Chicken, LARGE", "quantity_available"=>"50"},
                           "2"=>{"product_description"=>"($6/lb., 7-7.25 lbs)", "max_quantity_per_member"=>"4", "product_id"=>"501917461", "notes"=>"", "product_estimated"=>"true", "product_price"=>"42.0", "product_name"=>"Chicken, XXL", "quantity_available"=>"50"},
                           "3"=>{"product_description"=>"500ml", "max_quantity_per_member"=>"4", "product_id"=>"1588188741", "notes"=>"", "product_estimated"=>"false", "product_price"=>"18.0", "product_name"=>"Terra Sole olive oil", "quantity_available"=>"50"},
                           "4"=>{"product_description"=>"A medium-large, pasture-raised chicken.  ($6.50/lb., 3.75-4.5 lbs)", "max_quantity_per_member"=>"4", "product_id"=>"2026084183", "notes"=>"", "product_estimated"=>"true", "product_price"=>"26.0", "product_name"=>"Chicken, REGULAR", "quantity_available"=>"50"}},
                    }

    delivery = Delivery.new(delivery_hash)
    delivery.valid?.should == true

    delivery.save
    delivery.stock_items.size.should == 5

    Delivery.find(delivery.id).stock_items.size.should == 5

  end

  it "should calculate a finalized total from orders" do
    delivery = Factory(:delivery_with_orders)
    delivery.finalized_total.should == 0

    delivery.orders.each {|order| order.finalized_total = 10 }
    delivery.finalized_total.should == 10 * delivery.orders.size
  end

  it "should alphabetize associated orders by last name" do
    delivery = Factory(:delivery)
    Factory(:order, :delivery => delivery, :member => Factory(:member, :last_name => "Salant"))
    Factory(:order, :delivery => delivery, :member => Factory(:member, :last_name => "Aaker"))
    Factory(:order, :delivery => delivery, :member => Factory(:member, :last_name => "Reed"))

    delivery.orders.first.member.last_name.should == "Aaker"
    delivery.orders.last.member.last_name.should == "Salant"
  end

  it "should add pickups when passed an array of location ids" do
    delivery = Factory(:delivery)
    location = Factory(:location)
    
    delivery.create_pickups([location.id])
    delivery.locations.first.should == location
  end

end
