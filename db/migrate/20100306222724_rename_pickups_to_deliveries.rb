class RenamePickupsToDeliveries < ActiveRecord::Migration
  def self.up
    rename_table :pickups, :deliveries
    rename_column :orders, :pickup_id, :delivery_id
    rename_column :stock_items, :pickup_id, :delivery_id
  end

  def self.down
    rename_table :deliveries, :pickups
    rename_column :orders, :delivery_id, :pickup_id
    rename_column :orders, :delivery_id, :pickup_id
  end
end
