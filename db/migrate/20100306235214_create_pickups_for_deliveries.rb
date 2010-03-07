class CreatePickupsForDeliveries < ActiveRecord::Migration
  def self.up
    create_table :pickups do |t|
      t.integer :delivery_id
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pickups
  end
end
