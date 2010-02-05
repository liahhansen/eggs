class RenameMemberIdFieldsToUserId < ActiveRecord::Migration
  def self.up
    rename_column :orders, :member_id, :user_id
    rename_column :subscriptions, :member_id, :user_id
  end

  def self.down
    rename_column :orders, :user_id, :member_id
    rename_column :subscriptions, :user_id, :member_id
  end
end
