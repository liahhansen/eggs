class AddPositionToStockItems < ActiveRecord::Migration
  def self.up
    add_column :stock_items, :position, :integer


    # go set defaults on all past deliveries
    Delivery.all.each do |delivery|
      delivery.stock_items.each_with_index do |stock_item, i|
        stock_item.position = i+1
        stock_item.save!
      end
    end
  end

  def self.down
    remove_column :stock_items, :position
  end
end
