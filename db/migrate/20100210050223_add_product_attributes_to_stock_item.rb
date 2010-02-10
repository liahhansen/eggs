class AddProductAttributesToStockItem < ActiveRecord::Migration
  def self.up
    add_column :stock_items, :product_name, :string
    add_column :stock_items, :product_description, :text
    add_column :stock_items, :product_price, :float
    add_column :stock_items, :product_estimated, :boolean
  end

  def self.down
    remove_column :stock_items, :product_name
    remove_column :stock_items, :product_description
    remove_column :stock_items, :product_price
    remove_column :stock_items, :product_estimated
  end
end
