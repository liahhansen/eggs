class Order < ActiveRecord::Base
  belongs_to :member
  belongs_to :pickup
  has_many :order_items, :dependent => :destroy

  validates_presence_of :member_id, :pickup_id
  validate :member_must_exist, :pickup_must_exist

  def estimated_total
    total = 0
    order_items.each do |item|     
      total += item.stock_item.product.price * item.quantity
    end
    total
  end

  def member_must_exist
    errors.add(:member_id, "this member must exist") if member_id && !Member.find(member_id)
  end

  def pickup_must_exist
    errors.add(:pickup_id, "this pickup must exist") if pickup_id && !Pickup.find(pickup_id)
  end
  
end
