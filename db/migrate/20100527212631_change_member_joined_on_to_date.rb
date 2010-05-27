class ChangeMemberJoinedOnToDate < ActiveRecord::Migration
  def self.up
    change_column :members, :joined_on, :date
  end

  def self.down
    change_column :members, :joined_on, :datetime
  end
end
