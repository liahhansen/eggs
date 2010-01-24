class CreatePickups < ActiveRecord::Migration
  def self.up
    create_table :pickups do |t|
      t.string :name
      t.text :description
      t.integer :farm_id
      t.date :date
      t.string :status
      t.string :host
      t.string :location
      t.datetime :opening_at
      t.datetime :closing_at
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :pickups
  end
end
