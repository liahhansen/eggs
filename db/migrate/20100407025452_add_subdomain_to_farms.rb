class AddSubdomainToFarms < ActiveRecord::Migration
  def self.up
    add_column :farms, :subdomain, :string, :default => 'soulfood'
  end

  def self.down
    remove_column :farms, :subdomain
  end
end
