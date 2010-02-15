require 'spec_helper'

describe Importer do
  before(:each) do
    Factory(:farm)
    @importer = Importer.new
  end

  it "should list pickup files" do
    @importer.pickups.empty?.should == false
  end

  it "should list file headers" do
    @importer.pickups.each do |pickup|
      puts "Pickup for #{pickup.pickup_date}:"
      puts "  Headers (#{pickup.headers.size}): #{pickup.headers.join '  |  '}"
      puts "  Products (#{pickup.products.size}): #{pickup.products.join '  |  '}"
    end
  end
end

describe PickupImporter do
  before(:each) do
    @farm = Factory(:farm)
    @importer = PickupImporter.new "#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv"
  end

  it "should identify product names" do
    products = @importer.product_headers
    products.size.should == 8
  end

  it "should normalize product names" do
    products = @importer.product_headers
    products[0].should == "Chicken, REGULAR ($6.5/lb., 3.75-4.5 lbs)"
    products[7].should == "Terra Sole olive oil 500ml, $18"
  end

  it "should take pickup date from file name" do
    @importer.pickup.date.should == Date.parse("2010-01-13")
  end

  it "should find existing products by header name" do
    product = Factory(:product, :farm => @farm, :name => 'Chicken, REGULAR')
    @importer.farm.should == product.farm
    @importer.products[0].should == product
    @importer.products[0].new_record?.should == false
  end

  it "should create new products by header name" do
    @importer.products[1].name.should == 'Chicken, LARGE'
    @importer.products[1].new_record?.should == true
  end

#  it "should create a stock item for each product" do
#    @importer.pickup.stock_items.size.should == 8
#  end
end
