class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :phone_number
      t.string :neighborhood

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
