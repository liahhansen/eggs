class AddFarmIdToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :farm_id, :integer
  end

  def self.down
    remove_column :locations, :farm_id
  end
end
