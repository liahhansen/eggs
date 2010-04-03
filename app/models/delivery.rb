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

class Delivery < ActiveRecord::Base
  belongs_to :farm
  has_many :stock_items, :dependent => :destroy
  has_many :orders, :dependent => :destroy, :include => :member, :order => "members.last_name"
  has_many :pickups
  has_many :locations, :through => :pickups

  validates_presence_of :farm_id
  validates_presence_of :date

  accepts_nested_attributes_for :stock_items
  accepts_nested_attributes_for :orders

  def self.new_from_farm(farm)
    delivery = Delivery.new
    farm.products.each do |product|
      stock_item = delivery.stock_items.build(:product_id => product.id)
      stock_item.copy_product_attributes
    end
    return delivery
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

  def finalized_total
    total = 0
    orders.each do |order|
      total += order.finalized_total if order.finalized_total
    end
    total
  end

  def create_pickups(locations)
    locations.each do |location|
      Pickup.create(:location_id => location, :delivery_id => self.id)
    end
  end

  def pretty_status
    case status
    when 'notyetopen'
      return "Not Yet Open"
    when 'inprogress'
      return "In Progress"
    else
      return status.capitalize  
    end
  end

end
