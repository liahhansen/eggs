class AddNotesToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :notes, :text
  end

  def self.down
    remove_column :members, :notes
  end
end
