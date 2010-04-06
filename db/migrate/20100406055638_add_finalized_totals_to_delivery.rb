class AddFinalizedTotalsToDelivery < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :finalized_totals, :boolean, :default => false
  end

  def self.down
    remove_column :deliveries, :finalized_totals
  end
end
