require "csv"
require "importer"

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
      Location.delete_all
      User.delete_all
      RolesUser.delete_all
      puts "Deleted all deliveries, Products, Members, Users, Locations and their dependent models."
    end

    desc "Run data import from DIR."
    task :run => :environment do
      import_run(dir, farm)
    end

    desc "Import a single delivery file"
    task :run_single => :environment do
      import_file(filename, farm)
    end

    def dir
      ENV['DIR'] || "#{RAILS_ROOT}/../eggs_import/soul_food"
    end

    def farm
      Farm.find_by_name(ENV['FARM'] || "Soul Food Farm")
    end

    def filename
      ENV['FILE'] || raise("You must specify a file to import!")
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

    def import_file(file, farm)
      puts "Importing for #{farm.name} from #{file}."
      import = DeliveryImport.new(file,farm)
      puts "Importing #{file}"
      import.import!
      puts "Done."
    end
  end



  namespace :create do
    desc "creates admin user"
    task :admin => :environment do
      user = User.create!(:email => "admin@example.com", :password => "eggsrock", :password_confirmation => "eggsrock")
      user.has_role!(:admin)
    end

    desc "creates member & user for Soul Food Farm"
    task :user => :environment do
      member = Member.create!(:first_name => "John", :last_name => "Doe",
                              :email_address => "johndoe@example.com", :phone_number => "123-456-7890")
      subscription = Subscription.create(:farm => Farm.find_by_name("Soul Food Farm"), :member => member)
      user = User.create!(:email => member.email_address, :password => "eggsrock", :password_confirmation => "eggsrock", :member => member)
      user.has_role!(:member)
    end
  end

end

