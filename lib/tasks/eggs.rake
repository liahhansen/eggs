require "csv"

# Loads a single-delivery CSV file (exported from gDocs)
# and saves the following to the database:
#   * users (no subscription yet)
#   * products
#   * stock_items
#   * orders
#   * order_items



namespace :eggs do

  namespace :import do

    desc "Dry run import prints data to import from DIR."
    task :dry => :environment do
      import_dry(dir, farm)
    end


    desc "Deletes all deliveries, Products, Members, Locations and their dependent models"
    task :clean => :environment do
      Delivery.delete_all
      Product.delete_all
      Member.delete_all
      puts "Deleted all deliveries, Products, Members and their dependent models."
    end

    desc "Run data import from DIR."
    task :run => :environment do
      import_run(dir, farm)
    end

    def dir
      ENV['DIR'] || "#{RAILS_ROOT}/../eggs_import/soul_food"
    end

    def farm
      Farm.find_by_name(ENV['FARM'] || "Soul Food Farm")
    end

    def import_dry(dir, farm)
      puts "Importing from #{dir} for #{farm.name} (dry run)."
      importer = Importer.new(dir, farm)
      importer.imports.collect(&:deliveries).flatten.each do |delivery|
        puts "\n== Delivery for #{delivery.date} =="
        puts "== Stock Items:"
        delivery.stock_items.each do |item|
          puts "  #{item.product.name}"
          puts "    #{item.product.description}" if item.product.description
        end
      end
    end

    def import_run(dir, farm)
      puts "Importing for #{farm.name} from #{dir}."
      importer = Importer.new(dir, farm)
      importer.imports.each do |import|
        puts "  Importing #{import.file}."
        import.import!
      end
      puts "Done."
    end
  end

end

