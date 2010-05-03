class AddAddressToFarms < ActiveRecord::Migration
  def self.up
    add_column :farms, :address, :string
  end

  def self.down
    remove_column :farms, :address
  end
end
