class AddPriceCodeToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :price_code, :string
    add_column :stock_items, :product_price_code, :string
  end

  def self.down
    remove_column :products, :price_code
    remove_column :stock_items, :product_price_code
  end
end
