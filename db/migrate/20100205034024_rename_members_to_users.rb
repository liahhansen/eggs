class RenameMembersToUsers < ActiveRecord::Migration
  def self.up
    rename_table :members, :users
  end

  def self.down
    rename_table :users, :members
  end
end
