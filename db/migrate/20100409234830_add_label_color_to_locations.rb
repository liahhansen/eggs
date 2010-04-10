class AddLabelColorToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :label_color, :string, :default => "000000"
  end

  def self.down
    remove_column :locations, :label_color
  end
end
