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
  has_many :stock_items, :dependent => :destroy, :order => "product_name" do
    def with_quantity
      self.select {|item| item.quantity_available > 0 }
    end
  end
  has_many :orders, :dependent => :destroy, :include => :member, :order => "members.last_name" do
    def for_location(location)
      self.select {|order| order.location == location}
    end
  end
  has_many :pickups
  has_many :locations, :through => :pickups

  validates_presence_of :farm_id
  validates_presence_of :date

  accepts_nested_attributes_for :stock_items
  accepts_nested_attributes_for :orders

  liquid_methods :name, :farm, :date, :pretty_date, :pretty_closing_at

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

  def perform_deductions!
    return false if self.deductions_complete
    ActiveRecord::Base.transaction do
      orders.each do |order|
        subscription = Subscription.find_by_farm_id_and_member_id(farm.id, order.member.id)
        transaction = Transaction.new(:subscription_id => subscription.id,
                                      :amount => order.finalized_total,
                                      :debit => true,
                                      :date => Date.today,
                                      :order_id => order.id,
                                      :description => "Automatic debit for #{order.delivery.pretty_date} order pickup")
        transaction.save!
      end
      self.update_attribute(:deductions_complete, true)
    end
  end

  def create_new_stock_item_from_product(product)
    stock_item = stock_items.build(:product_id => product.id)
    stock_item.copy_product_attributes
    save!

    orders.each {|order|
      order.order_items.build(:stock_item_id => stock_item.id, :quantity => 0)
      order.save!
    }

    return stock_item
  end

end
