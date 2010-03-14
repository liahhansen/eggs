require 'spec_helper'

describe Importer do
  before(:each) do
    farm = Factory(:farm)
    @importer = Importer.new("#{RAILS_ROOT}/db/import", farm)
  end

  it "should list imports" do
    @importer.imports.size.should == 2
  end
end

describe DeliveryImport do
  context "Soul Food Farm" do
    before :each do
      @farm = Factory(:farm)
      @chicken_regular = Factory(:product, :farm => @farm, :name => 'Chicken, REGULAR')
      @import = DeliveryImport.new("#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv", @farm)
    end

    context "Creating Members, Orders and OrderItems" do

      before :each do
        @kathryn = Factory(:member, :first_name => "Kathryn", :last_name => "Aaker", :email_address => 'kathryn@kathrynaaker.com')
      end

      it "should find existing member" do
        kathryn = Factory(:member, :first_name => "Kathryn", :last_name => "Aaker", :email_address => 'kathryn@kathrynaaker.com')
        @import.members.size.should == 2
        @import.members[0].should == @kathryn
        @import.members[0].subscriptions[0].farm.should == @farm
      end

      it "should create new member" do
        @import.members[1].first_name.should == "Alon"
        @import.members[1].last_name.should == "Salant"
        @import.members[1].subscriptions[0].farm.should == @farm
        @import.members[1].new_record?.should == true
      end

      it "should create new orders" do
        @import.orders.size.should == 4
        @import.orders[0].member.should == @kathryn
        @import.orders[0].delivery.name.should == "SF Potrero"
        @import.orders[0].finalized_total.should == 30.55

        @import.orders[1].member.first_name.should == "Alon"
        @import.orders[1].delivery.name.should == "SF Potrero"
      end

      it "should create order items for each stock item" do
        @import.orders[0].order_items.size.should == 8
        @import.orders[0].order_items[0].stock_item.product.should == @chicken_regular
        @import.orders[0].order_items[0].quantity.should == 1
        @import.orders[0].order_items[1].quantity.should == 0
      end

    end

    context "Creating Products, deliveries and StockItems" do
      before :each do
      end

      it "should identify columns" do
        columns = @import.columns
        columns.size.should == 9
        columns[:timestamp].should == 0
        columns[:first_name].should == 2
        columns[:last_name].should == 1
        columns[:email].should == 3
        columns[:phone].should == 4
        columns[:location].should == 7
        columns[:products].size.should == 8
        columns[:products][@chicken_regular].should == 8
        columns[:products][@import.products[1]].should == 9
        columns[:notes].should == 18
        columns[:total].should == 20
      end

      it "should have multiple location names" do
        @import.location_names.should == ['SF Potrero', 'Farm']
      end

      it "should have multiple deliveries" do
        @import.deliveries.size.should == 2
        @import.deliveries[0].name.should == 'SF Potrero'
        @import.deliveries[1].name.should == 'Farm'
      end

      it "should take delivery date from file name" do
        @import.deliveries.first.date.should == Date.parse("2010-01-13")
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
        @import.products[1].new_record?.should == false
      end

      it "should create a stock item for each product" do
        @import.deliveries[0].stock_items.size.should == 8
        @import.deliveries[0].stock_items[0].product.should == @chicken_regular
      end
    end

    context "Saving the import" do
      it "should create everything" do
        DeliveryImport.new("#{RAILS_ROOT}/db/import/SFF CSA 1-13-10 TEST.csv", @farm).import!

        Delivery.count.should == 2
        StockItem.count.should == 16
        Product.count.should == 8
        Member.count.should == 2
        Order.count.should == 4
      end
    end

  end

  context "Clark Summit" do
    before :each do
      @farm = Factory(:farm, :name => 'Clark Summit')
      @import = DeliveryImport.new("#{RAILS_ROOT}/db/import/Clark Summit 2-3-10 TEST.csv", @farm)
    end

    it "should identify columns" do
      columns = @import.columns
      columns.size.should == 9
      columns[:timestamp].should == 2
      columns[:first_name].should == 1
      columns[:last_name].should == 0
      columns[:email].should == 3
      columns[:phone].should == 4
      columns[:location].should == 6
      columns[:products].size.should == 53
      columns[:notes].should == 61
      columns[:total].should == 63
    end

    it "should create new orders" do
      @import.orders.size.should == 4
      @import.orders[0].member.first_name.should == 'Sue'
      @import.orders[0].finalized_total.should == 154.14
    end

    it "should have multiple location names" do
      @import.location_names.should == ['EB','MC']
    end

  end
end
