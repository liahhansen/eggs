class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :member_id
      t.integer :pickup_id
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
