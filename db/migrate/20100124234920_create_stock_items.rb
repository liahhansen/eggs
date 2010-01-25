class CreateStockItems < ActiveRecord::Migration
  def self.up
    create_table :stock_items do |t|
      t.integer :pickup_id
      t.integer :product_id
      t.integer :max_quantity_per_member
      t.integer :quantity_available
      t.integer :substitutions_available
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :stock_items
  end
end
