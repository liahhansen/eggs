require 'spec_helper'

describe Importer do
  before(:each) do
    Factory(:farm)
    @importer = Importer.new
  end

  it "should list pickups" do
    @importer.pickups.size.should == 2
  end
end

describe PickupImport do
  before :each do
    @farm = Factory(:farm)
    @import = PickupImport.new "#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv"
  end

  context "Creating Members, Orders and OrderItems" do

    before :each do
    end

    it "should find existing member" do
      kathryn = Factory(:member, :first_name => "Kathryn", :last_name => "Aaker", :email_address => 'kathryn@kathrynaaker.com')
      @import.members.size.should == 2
      @import.members[0].should == kathryn
      @import.members[0].subscriptions[0].farm.should == @farm
    end

    it "should create new member" do
      @import.members[0].first_name.should == "Kathryn"
      @import.members[0].last_name.should == "Aaker"
      @import.members[0].subscriptions[0].farm.should == @farm
      @import.members[0].new_record?.should == true
    end

  end

  context "Creating Products, Pickups and StockItems" do
    before :each do
      @chicken_regular = Factory(:product, :farm => @farm, :name => 'Chicken, REGULAR')
    end

    it "should identify product names" do
      products = @import.product_headers
      products.size.should == 8
    end

    it "should have multiple location names" do
      @import.location_names.should == ['SF Potrero', 'Farm']
    end

    it "should normalize product names" do
      products = @import.product_headers
      products[0].should == "Chicken, REGULAR ($6.50/lb., 3.75-4.5 lbs)"
      products[7].should == "Terra Sole olive oil, 500ml, $18"
    end

    it "should have multiple pickups" do
      @import.pickups.size.should == 2
      @import.pickups[0].name.should == 'SF Potrero'
      @import.pickups[1].name.should == 'Farm'
    end

    it "should take pickup date from file name" do
      @import.pickups.first.date.should == Date.parse("2010-01-13")
    end

    it "should find existing products by header name" do
      @import.farm.should == @farm
      @import.products[0].should == @chicken_regular
      @import.products[0].new_record?.should == false
    end

    it "should create new products by header name" do
      @import.products[1].name.should == 'Chicken, LARGE'
      @import.products[1].description.should == '$6/lb., 4.5-5.5 lbs'
      @import.products[1].farm.should == @farm
      @import.products[1].new_record?.should == true
    end

    it "should create a stock item for each product" do
      @import.pickups[0].stock_items.size.should == 8
      @import.pickups[0].stock_items[0].product.should == @chicken_regular
    end

    it "should save pickups" do
      importer = PickupImport.new "#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv"
      importer.import!
      Pickup.count.should == 2
      StockItem.count.should == 16
      Product.count.should == 8
    end
  end
end
