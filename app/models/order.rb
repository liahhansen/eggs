class Order < ActiveRecord::Base
  belongs_to :user
  belongs_to :pickup
  has_many :order_items, :dependent => :destroy do
    def with_quantity
      self.select {|item| item.quantity > 0 }
    end
  end

  validates_presence_of :user_id, :pickup_id
  validate :user_must_exist, :pickup_must_exist, :total_meets_minimum

  accepts_nested_attributes_for :order_items

  def self.new_from_pickup(pickup)
    order = Order.new
    pickup.stock_items.each do |item|
      order.order_items.build(:stock_item_id => item.id, :quantity => 0)
    end
    return order
  end

  def estimated_total
    total = 0
    order_items.each do |item|     
      total += item.stock_item.product_price * item.quantity
    end
    total
  end


  # VALIDATIONS
  
  def user_must_exist
    errors.add(:user_id, "this user must exist") if user_id && !User.find(user_id)
  end

  def pickup_must_exist
    errors.add(:pickup_id, "this pickup must exist") if pickup_id && !Pickup.find(pickup_id)
  end

  def total_meets_minimum
    if pickup
      if pickup.minimum_order_total
        errors.add_to_base("your order does not meet the minimum") if estimated_total < pickup.minimum_order_total
      end
    end
  end
  
end
