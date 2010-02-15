class AddBalanceToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :balance, :float
  end

  def self.down
    remove_column :members, :balance
  end
end
