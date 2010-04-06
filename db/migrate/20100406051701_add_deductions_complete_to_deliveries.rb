class AddDeductionsCompleteToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :deductions_complete, :boolean, :default => 0
  end

  def self.down
    remove_column :deliveries, :deductions_complete
  end
end
