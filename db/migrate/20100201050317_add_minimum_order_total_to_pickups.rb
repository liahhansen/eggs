class AddMinimumOrderTotalToPickups < ActiveRecord::Migration
  def self.up
    add_column :pickups, :minimum_order_total, :integer
  end

  def self.down
    remove_column :pickups, :minimum_order_total
  end
end
