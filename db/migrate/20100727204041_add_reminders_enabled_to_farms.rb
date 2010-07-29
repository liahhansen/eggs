class AddRemindersEnabledToFarms < ActiveRecord::Migration
  def self.up
    add_column :farms, :reminders_enabled, :boolean, :default => false
  end

  def self.down
    remove_column :farms, :reminders_enabled
  end
end
