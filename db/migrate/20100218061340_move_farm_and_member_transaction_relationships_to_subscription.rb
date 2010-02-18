class MoveFarmAndMemberTransactionRelationshipsToSubscription < ActiveRecord::Migration
  def self.up
    remove_column :transactions, :farm_id
    remove_column :transactions, :member_id
    add_column :transactions, :subscription_id, :integer
  end

  def self.down
    add_column :transactions, :farm_id, :integer
    add_column :transactions, :member_id, :integer
    remove_column :transactions, :subscription_id
  end
end
