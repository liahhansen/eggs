class AddConfigToFarm < ActiveRecord::Migration
  def self.up
    add_column :farms, :require_deposit, :boolean, :default => true
    add_column :farms, :require_mailinglist, :boolean, :default => true
    add_column :farms, :request_referral, :boolean, :default => true
  end

  def self.down
    remove_column :farms, :request_referral
    remove_column :farms, :require_mailinglist
    remove_column :farms, :require_deposit
  end
end
