class MoveBalanceToTransaction < ActiveRecord::Migration
  def self.up
    remove_column :subscriptions, :balance
    add_column :transactions, :balance, :float
  end

  def self.down
    add_column :subscriptions, :balance, :float
    remove_column :transactions, :balance
  end
end
