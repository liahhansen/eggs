class AddPaypalAndContactInfoToFarms < ActiveRecord::Migration
  def self.up
    add_column :farms, :paypal_link, :string
    add_column :farms, :contact_email, :string
    add_column :farms, :contact_name, :string
  end

  def self.down
    remove_column :farms, :contact_name
    remove_column :farms, :contact_email
    remove_column :farms, :paypal_link
  end
end
