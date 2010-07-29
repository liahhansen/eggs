class CreateDeliveryOrderReminders < ActiveRecord::Migration
  def self.up
    create_table :delivery_order_reminders do |t|
      t.integer :delivery_id
      t.integer :email_template_id
      t.boolean :delivered, :default => false
      t.datetime :deliver_at

      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_order_reminders
  end
end
