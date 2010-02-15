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

class Pickup < ActiveRecord::Base
  belongs_to :farm
  has_many :stock_items, :dependent => :destroy
  has_many :orders, :dependent => :destroy

  validates_presence_of :farm_id

  accepts_nested_attributes_for :stock_items
  accepts_nested_attributes_for :orders

  def self.new_from_farm(farm)
    pickup = Pickup.new
    farm.products.each do |product|
      stock_item = pickup.stock_items.build(:product_id => product.id)
      stock_item.copy_product_attributes
    end
    return pickup
  end


  define_easy_dates do
    format_for :date, :format => "%A, %b %e, %Y", :as => "pretty_date"
    format_for :opening_at, :format => "%I:%M%p, %m/%d/%y" 
    format_for :closing_at, :format => "%I:%M%p, %m/%d/%y"
  end

  def estimated_total
    total = 0
    orders.each do |order|
      total += order.estimated_total
    end
    total
  end

  def map_link
    "http://mapof.it/#{location}"
  end

end
