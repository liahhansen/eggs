class AddKeyToFarm < ActiveRecord::Migration
  def self.up
    add_column :farms, :key, :string
  end

  def self.down
    remove_column :farms, :key
  end
end
