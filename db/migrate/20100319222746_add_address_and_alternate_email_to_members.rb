class AddAddressAndAlternateEmailToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :address, :string
    add_column :members, :alternate_email, :string
  end

  def self.down
    remove_column :members, :alternate_email
    remove_column :members, :address
  end
end
