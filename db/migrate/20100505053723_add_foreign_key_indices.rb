class AddForeignKeyIndices < ActiveRecord::Migration
  def self.up
    #add_index :table_name, :column_name

    add_index :deliveries, :farm_id
    add_index :email_templates, :farm_id
    add_index :email_templates, [:farm_id, :identifier]
    add_index :farms, :name
    add_index :farms, :subdomain
    add_index :locations, :farm_id
    add_index :order_items, :stock_item_id
    add_index :order_items, :order_id
    add_index :orders, :member_id
    add_index :orders, :delivery_id
    add_index :orders, :location_id
    add_index :pickups, :delivery_id
    add_index :pickups, :location_id
    add_index :products, :farm_id
    add_index :roles, [:authorizable_type, :authorizable_id]
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
    add_index :roles_users, [:user_id, :role_id]
    add_index :snippets, :farm_id
    add_index :snippets, [:farm_id, :identifier]
    add_index :stock_items, :delivery_id
    add_index :stock_items, :product_id
    add_index :subscriptions, :farm_id
    add_index :subscriptions, :member_id
    add_index :transactions, :order_id
    add_index :transactions, :subscription_id
    add_index :users, :member_id
    add_index :users, :perishable_token


  end

  def self.down
  end
end
