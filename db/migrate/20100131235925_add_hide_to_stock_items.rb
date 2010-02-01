class AddHideToStockItems < ActiveRecord::Migration
  def self.up
    add_column :stock_items, :hide, :boolean
  end

  def self.down
    remove_column :stock_items, :hide
  end
end
