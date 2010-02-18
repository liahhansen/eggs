class MoveBalanceToSubscription < ActiveRecord::Migration
  def self.up
    remove_column :members, :balance
    add_column :subscriptions, :balance, :float
  end

  def self.down
    add_column :members, :balance, :float
    remove_column :subscriptions, :balance
  end
end
