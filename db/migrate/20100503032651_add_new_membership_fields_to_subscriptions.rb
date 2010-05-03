class AddNewMembershipFieldsToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :deposit_type, :string, :default => "unknown (old system)"
    add_column :subscriptions, :deposit_received, :boolean, :default => true
    add_column :subscriptions, :joined_mailing_list, :boolean, :default => true
    add_column :subscriptions, :pending, :boolean, :default => false
    add_column :subscriptions, :referral, :string
  end

  def self.down
    remove_column :subscriptions, :pending
    remove_column :subscriptions, :joined_mailing_list
    remove_column :subscriptions, :deposit_received
    remove_column :subscriptions, :deposit_type
    remove_column :subscriptions, :referral
    remove_column :subscriptions, :deposit_type
  end
end
