class AddProductCategoryToStockItems < ActiveRecord::Migration
  def self.up
    add_column :stock_items, :product_category, :string
  end

  def self.down
    remove_column :stock_items, :product_category
  end
end
