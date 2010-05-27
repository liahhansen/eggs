class AddPrivateNotesToSubscription < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :private_notes, :text
  end

  def self.down
    remove_column :subscriptions, :private_notes
  end
end
