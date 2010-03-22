class ChangeUsersUsernameToEmail < ActiveRecord::Migration
  def self.up
    rename_column :users, :username, :email
  end

  def self.down
    rename_column :users, :username, :email
  end
end
