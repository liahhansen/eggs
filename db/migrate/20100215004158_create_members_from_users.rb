class CreateMembersFromUsers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :phone_number
      t.string :neighborhood
      t.datetime :joined_on

      t.timestamps
    end

    change_table :users do |t|
      t.remove :first_name
      t.remove :last_name
      t.remove :neighborhood
      t.remove :email_address
      t.integer :member_id
    end

    rename_column :orders, :user_id, :member_id
    rename_column :subscriptions, :user_id, :member_id
    
  end

  def self.down
    drop_table :members

    change_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :neighborhood
      t.string :email_address
      t.remove :member_id
    end

    rename_column :orders, :member_id, :user_id
    rename_column :subscriptions, :member_id, :user_id

    
  end
end
