class AddMailingListSubscribeAddressToFarms < ActiveRecord::Migration
  def self.up
    add_column :farms, :mailing_list_subscribe_address, :string
  end

  def self.down
    remove_column :farms, :mailing_list_subscribe_address
  end
end
