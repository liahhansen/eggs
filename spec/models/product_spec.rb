# == Schema Information
#
# Table name: products
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  price       :float
#  estimated   :boolean(1)
#  farm_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#  price_code  :string(255)
#

require 'spec_helper'

describe Product do
  before(:each) do
    @valid_attributes = {
      :farm_id => Factory(:farm).id,
      :name => "Extra Large Chicken"
    }
  end

  it "should create a new instance given valid attributes" do
    Product.create!(@valid_attributes)
  end

  it "can have a category" do
    product = Factory(:product, :category => "poultry")
    product.category.should == "poultry"

    
  end
end
