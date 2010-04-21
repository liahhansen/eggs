# == Schema Information
#
# Table name: orders
#
#  id              :integer(4)      not null, primary key
#  member_id       :integer(4)
#  delivery_id     :integer(4)
#  notes           :text
#  created_at      :datetime
#  updated_at      :datetime
#  finalized_total :float
#  location_id     :integer(4)
#

class Order < ActiveRecord::Base
  belongs_to :member
  belongs_to :delivery
  has_many :transactions
  has_many :order_items, :dependent => :destroy do
    def with_quantity
      self.select {|item| item.quantity && (item.quantity > 0) }
    end
  end
  belongs_to :location

  validates_presence_of :member_id, :delivery_id
  validate :member_must_exist, :delivery_must_exist, :total_meets_minimum

  accepts_nested_attributes_for :order_items

  liquid_methods :member, :delivery, :finalized_total, :location, :notes,
                 :order_items, :estimated_total, :order_items_with_quantity

  def self.new_from_delivery(delivery)
    order = Order.new
    delivery.stock_items.each do |item|
      order.order_items.build(:stock_item_id => item.id, :quantity => 0)
    end
    return order
  end

  def estimated_total
    total = 0
    order_items.with_quantity.each do |item|
      next unless item.stock_item.product_price
      total += item.stock_item.product_price * item.quantity
    end
    total
  end

  def total_items_quantity
    order_items.with_quantity.inject(0){|total, item|total + item.quantity}
  end

  # VALIDATIONS
  
  def member_must_exist
    errors.add(:member_id, "this member must exist") if member_id && !Member.find(member_id)
  end

  def delivery_must_exist
    errors.add(:delivery_id, "this delivery must exist") if delivery_id && !Delivery.find(delivery_id)
  end

  def total_meets_minimum
    if delivery
      if delivery.minimum_order_total
        errors.add_to_base("your order does not meet the minimum") if estimated_total < delivery.minimum_order_total
      end
    end
  end

  def deliver_finalized_order_confirmation!
    template = EmailTemplate.find_by_identifier("order_finalized_notification")
    template.deliver_to(self.member.email_address, :order => self) if template
  end

  def deliver_pickup_reminder!
    template = EmailTemplate.find_by_identifier("order_pickup_reminder")
    template.deliver_to(self.member.email_address, :order => self) if template
  end
  
end
