# == Schema Information
#
# Table name: stock_items
#
#  id                      :integer(4)      not null, primary key
#  delivery_id             :integer(4)
#  product_id              :integer(4)
#  max_quantity_per_member :integer(4)
#  quantity_available      :integer(4)
#  substitutions_available :boolean(1)
#  notes                   :text
#  created_at              :datetime
#  updated_at              :datetime
#  hide                    :boolean(1)
#  product_name            :string(255)
#  product_description     :text
#  product_price           :float
#  product_estimated       :boolean(1)
#  product_price_code      :string(255)
#

class StockItem < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :product

  validates_associated :product

  before_create :copy_product_attributes

  liquid_methods :product_name, :product_description, :product_price, :product_estimated, :product_price_code

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
      self.product_category     = product.category      if !self.product_category
      self.quantity_available   = product.default_quantity if !self.quantity_available
      self.max_quantity_per_member = product.default_per_member if !self.max_quantity_per_member 
    end
  end

  def quantity_ordered
    OrderItem.with_quantity.find_all_by_stock_item_id(id).inject(0){|total, item| total + item.quantity}
  end

  def quantity_remaining
    quantity_available - quantity_ordered
  end

  def available_per_member
    [max_quantity_per_member, quantity_remaining].min
  end

end
