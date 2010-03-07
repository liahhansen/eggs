class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :host_name
      t.string :host_phone
      t.string :host_email
      t.string :address
      t.text :notes
      t.string :time_window

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
