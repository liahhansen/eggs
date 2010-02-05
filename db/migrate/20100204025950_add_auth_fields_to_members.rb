class AddAuthFieldsToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :crypted_password, :string
    add_column :members, :password_salt, :string
    add_column :members, :persistence_token, :string
    add_column :members, :username, :string
  end

  def self.down
    remove_column :members, :username
    remove_column :members, :persistence_token
    remove_column :members, :password_salt
    remove_column :members, :crypted_password
  end
end
