class AddFinalizedTotalToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :finalized_total, :float
  end

  def self.down
    remove_column :orders, :finalized_total
  end
end
