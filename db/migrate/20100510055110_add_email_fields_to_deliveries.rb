class AddEmailFieldsToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :email_reminder_sent, :boolean, :default => false
    add_column :deliveries, :email_totals_sent, :boolean, :default => false
  end

  def self.down
    remove_column :deliveries, :email_totals_sent
    remove_column :deliveries, :email_reminder_sent
  end
end
