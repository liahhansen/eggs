class AddStatusOverrideToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :status_override, :boolean, :default => false
  end

  def self.down
    remove_column :deliveries, :status_override
  end
end
