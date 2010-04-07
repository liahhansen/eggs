class AddDefaultQuantityAndDefaultPerMemberToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :default_quantity, :integer, :default => 100
    add_column :products, :default_per_member, :integer, :default => 4
  end

  def self.down
    remove_column :products, :default_per_member
    remove_column :products, :default_quantity
  end
end
