class AddPaypalAccountToFarm < ActiveRecord::Migration
  def self.up
    add_column :farms, :paypal_account, :string
  end

  def self.down
    remove_column :farms, :paypal_account
  end
end
