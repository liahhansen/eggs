# == Schema Information
#
# Table name: stock_items
#
#  id                      :integer         not null, primary key
#  pickup_id               :integer
#  product_id              :integer
#  max_quantity_per_member :integer
#  quantity_available      :integer
#  substitutions_available :boolean
#  notes                   :text
#  created_at              :datetime
#  updated_at              :datetime
#  hide                    :boolean
#  product_name            :string(255)
#  product_description     :text
#  product_price           :float
#  product_estimated       :boolean
#

class StockItem < ActiveRecord::Base
  belongs_to :pickup
  belongs_to :product

  validates_associated :product

  before_create :copy_product_attributes

  def after_initialize
    self.max_quantity_per_member = 4 if !self.max_quantity_per_member
    self.quantity_available = 50 if !self.quantity_available
  end

  def sold_out?

    items = OrderItem.find_all_by_stock_item_id(id)

    total_ordered = 0
    items.each do |item|
      total_ordered += item.quantity
    end

    total_ordered >= quantity_available ? true : false
    
  end

  def copy_product_attributes
    if(product)
      self.product_name         = product.name          if !self.product_name
      self.product_description  = product.description   if !self.product_description
      self.product_price        = product.price         if !self.product_price
      self.product_estimated    = product.estimated     if self.product_estimated == nil
      self.product_price_code   = product.price_code    if !self.product_price_code
    end
  end

  def quantity_ordered
    OrderItem.with_quantity.find_all_by_stock_item_id(id).inject(0){|total, item| total + item.quantity}
  end

  def quantity_remaining
    quantity_available - quantity_ordered
  end

end
