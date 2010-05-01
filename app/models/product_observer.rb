class ProductObserver < ActiveRecord::Observer
  def after_create(product)
    deliveries = product.farm.deliveries
    deliveries.each do |delivery|
      if delivery.status != "archived"
        delivery.create_new_stock_item_from_product(product)
      end
    end
  end
end
