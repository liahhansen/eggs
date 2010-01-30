require "csv"

# Loads a single-pickup CSV file (exported from gDocs)
# and saves the following to the database:
#   * members (no subscription yet)
#   * products
#   * stock_items
#   * orders
#   * order_items



namespace :eggs do
	desc "Import pickup CSV with 'rake eggs:import_pickup FILE=/path/to.csv SAVE=true'"
	task :import_pickup => :environment do
      puts "Importing #{ENV['FILE']}"
      puts "Saving..." if ENV['SAVE'] == "true"
      file = ENV['FILE']
      @orders = CSV.read(file)

      @do_save = ENV['SAVE'] == "true"

      clear_tables [Product,Member,Order,OrderItem,StockItem,Subscription] if @do_save
      create_products @orders.first
      create_members
      puts "Finished with save: #{@do_save}"
    end

    def clear_tables(tables)
      puts "Clearing tables: #{tables.length}"
      
      tables.each do |t|
        t.delete_all
      end
    end

    def create_members
      lines = @orders.find_all do |row|
        row[1] != "Last name" && row[3] != "TOTALS"
      end

      puts "Creating members... (#{lines.size})"      

      lines.each do |r|
        member = Member.new
        member.first_name = r[2]
        member.last_name = r[1]
        member.email_address = r[3]
        member.phone_number = r[4]
        member.neighborhood = r[6]
        member.save if @do_save
        create_subscription member
        
        create_orders r, member
      end
    end

    def create_subscription(member)
      sub = Subscription.new
      sub.farm_id = Farm.find_by_name("Soul Food Farm").id
      sub.member_id = member.id
      sub.save if @do_save
    end

    def create_orders(row, member)
      puts "Creating order for (#{member.last_name})"      

      order = Order.new
      order.member_id = member.id
      order.pickup_id = Pickup.find_by_name("Emeryville").id
      order.save if @do_save
      create_order_items row, order
    end

    def create_order_items(row, order)
      cols = [8,9,10,12,13,14,15]
      items = []

      cols.each_with_index do |col, i|
        q = row[col].to_i
        if q != nil && q != 0
          item = OrderItem.new
          item.stock_item_id = @stock_items[i].id
          item.order_id = order.id
          item.quantity = q
          item.save if @do_save
          items.push item
        end
        
      end

      puts "Creating items for order... (#{items.size})"            
      
    end

    def create_products(row)
      product_arr = []
      products = row[8..10] + row[12..15]

      puts "Creating products... (#{products.size})"      

      products.each do |p|
        product = Product.new
        product.farm_id = Farm.find_by_name("Soul Food Farm").id
        product.name = p
        product.save if @do_save
        product_arr.push product
      end

      create_stock_items product_arr
    end

    # just create a stock item for every product with some fictional quantities
    def create_stock_items(product_list)
      puts "Creating stock_items... (#{product_list.size})"
      @stock_items = []

      product_list.each do |p|
        item = StockItem.new
        item.pickup_id = Pickup.find_by_name("Emeryville").id
        item.product_id = p.id
        item.max_quantity_per_member = 5
        item.quantity_available = 50
        item.substitutions_available = false
        item.save if @do_save
        @stock_items.push item
      end
    end

end

