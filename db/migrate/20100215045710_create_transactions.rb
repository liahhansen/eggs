class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.date :date
      t.float :amount
      t.string :description
      t.integer :member_id
      t.integer :order_id

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
