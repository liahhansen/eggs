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

describe PickupImporter do
  before(:each) do
    @farm = Factory(:farm)
    @chicken_regular = Factory(:product, :farm => @farm, :name => 'Chicken, REGULAR')
    @importer = PickupImporter.new "#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv"
  end

  it "should identify product names" do
    products = @importer.product_headers
    products.size.should == 8
  end

  it "should have multiple location names" do
    @importer.location_names.should == ['SF Potrero', 'Farm']
  end

  it "should normalize product names" do
    products = @importer.product_headers
    products[0].should == "Chicken, REGULAR ($6.5/lb., 3.75-4.5 lbs)"
    products[7].should == "Terra Sole olive oil 500ml, $18"
  end

  it "should have multiple pickups" do
    @importer.pickups.size.should == 2
    @importer.pickups[0].name.should == 'SF Potrero'
    @importer.pickups[1].name.should == 'Farm'
  end

  it "should take pickup date from file name" do
    @importer.pickups.first.date.should == Date.parse("2010-01-13")
  end

  it "should find existing products by header name" do
    @importer.farm.should == @farm
    @importer.products[0].should == @chicken_regular
    @importer.products[0].new_record?.should == false
  end

  it "should create new products by header name" do
    @importer.products[1].name.should == 'Chicken, LARGE'
    @importer.products[1].description.should == '$6/lb., 4.5-5.5 lbs'
    @importer.products[1].farm.should == @farm
    @importer.products[1].new_record?.should == true
  end

  it "should create a stock item for each product" do
    @importer.pickups[0].stock_items.size.should == 8
    @importer.pickups[0].stock_items[0].product.should == @chicken_regular
  end

  it "should save pickups" do
    importer = PickupImporter.new "#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv"
    importer.import!
    Pickup.count.should == 2
    StockItem.count.should == 16
    Product.count.should == 8
  end
end
