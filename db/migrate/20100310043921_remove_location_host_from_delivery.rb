class RemoveLocationHostFromDelivery < ActiveRecord::Migration
  def self.up
    remove_column :deliveries, :host
    remove_column :deliveries, :location
  end

  def self.down
    add_column :deliveries, :host, :string
    add_column :deliveries, :location, :string
  end
end
