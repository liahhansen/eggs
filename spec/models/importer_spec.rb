require 'spec_helper'

describe Importer do
  before(:each) do
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
    @importer = PickupImporter.new "#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv"
  end

  it "should identify product names" do
    products = @importer.products
    products.size.should == 8
  end

  it "should normalize product names" do
    products = @importer.products
    products[0].should == "Chicken, REGULAR ($6.5/lb., 3.75-4.5 lbs)"
    products[7].should == "Terra Sole olive oil 500ml, $18"
  end

  it "should take pickup date from file name" do
    @importer.pickup_date.should == Date.parse("2010-01-13")
  end
end
