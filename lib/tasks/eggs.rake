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

    namespace :products do
      desc "Dry run import products"
      task :dry => :environment do
        puts "attempting to dry run"
        import_products_dry(filename,farm)
      end

      desc "Import Products"
      task :run => :environment do
        import_products_run(filename,farm)
      end

      desc "Clean Products for Farm"
      task :clean => :environment do
        if(farm)
          Product.delete_all "farm_id = #{farm.id}"
        end
      end

      def import_products_dry(file,farm)
        puts "Importing from #{file} for #{farm.name} (dry run)."
        importer = ProductImport.new(file,farm)
        importer.products.each do |product|
          puts "#{product.category} - #{product.name} - #{product.description}"
          puts "#{product.price} - #{product.price_code} - #{product.estimated} = #{product.farm_id}"
          puts "---------"
        end
      end

      def import_products_run(file,farm)
        puts "Importing from #{file} for #{farm.name}."
        importer = ProductImport.new(file,farm)
        importer.import!
        puts "Imported #{importer.products.size} products"
      end

      def farm
        Farm.find_by_name(ENV['FARM'] || raise("you must specify a farm!"))
      end

      def filename
        ENV['FILE'] || raise("You must specify a file to import!")
      end
    end

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
      ENV['DIR'] || "#{Rails.root}/../eggs_import/soul_food"
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


   namespace :email do

    namespace :inactive do
      
      desc "Dry run of inactive email."
      task :dry => :environment do
        users = get_inactive_users_for_farm(farm)
        users.each do |user|
          puts user.email
        end
      end

      desc "Sends all inactive users a welcome/activation email"
      task :run_welcome => :environment do
        users = get_inactive_users_for_farm(farm)
        users.each do |user|
          puts "emailing: #{user.email}"
          user.deliver_welcome_and_activation!
        end
      end

      desc "Emails a single user a welcome and activation message"
      task :run_welcome_single => :environment do
        user = single_user
        user.deliver_welcome_and_activation!
        puts "Done."
      end

      def get_inactive_users_for_farm(farm)
        puts "getting list of inactive users"
        users = User.all.reject do |user|
          user.member == nil
        end
        users = users.reject do |user|
         user.active? || !user.member.farms.include?(farm)
        end
        puts "Found #{users.length} users."
        return users
      end

      def farm
        Farm.find_by_name(ENV['FARM'] || raise("You must specify a farm name!"))
      end

      def single_user
        User.find_by_email(ENV['EMAIL'] || raise("You must specify a user email from the system"))
      end

    end



   end

  namespace :manage do

    desc "Copies questions from farm to deliveries and orders"
    task :copy_product_questions => :environment do

      farm = Farm.find_by_name("Soul Food Farm")

      deliveries = farm.deliveries
      deliveries.each do |delivery|
        if delivery.status != "archived"

          # copy from product questions into deliveries
          farm.product_questions.each do |product_question|
            delivery_question = delivery.delivery_questions.build(:product_question_id => product_question.id)
            delivery_question.copy_product_question_attributes
          end
          delivery.save!
          puts "----"
          puts "#{delivery.name} saved with #{farm.product_questions.size} questions"


          # copy from deliveries into orders
          delivery.delivery_questions.each do |delivery_question|
            delivery.orders.each do |order|
              order.order_questions.build(:delivery_question_id => delivery_question.id,
                                          :option_code => '',
                                          :option_string => '')
              order.save!
            end
            puts "copied questions to #{delivery.orders.size} orders"
          end
        end
      end
      
    end
  end


end

