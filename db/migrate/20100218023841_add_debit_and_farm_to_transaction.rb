class AddDebitAndFarmToTransaction < ActiveRecord::Migration
  def self.up
    add_column :transactions, :debit, :boolean
    add_column :transactions, :farm_id, :integer 
  end

  def self.down
    remove_column :transactions, :debit
    remove_column :transactions, :farm_id
  end
end
