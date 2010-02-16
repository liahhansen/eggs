class Importer

  def initialize(dir = "#{RAILS_ROOT}/db/import")
    @dir = dir
  end

  def pickups
    imports.collect(&:pickups).flatten
  end

  def import!
    imports.collect do |import|
      import.import!
    end
  end

  def imports
    Dir["#{@dir}/*.csv"].collect {|file|  PickupImport.new file}
  end

end

class PickupImport
  attr_reader :file, :rows, :farm

  def initialize(file)
    @file = file
    @rows = CSV.read file
    @farm = Farm.find_by_name('Soul Food Farm') || raise("Unable to find farm with name 'Soul Food Farm'")
  end

  def import!
    pickups.each {|pickup| pickup.save!}
    members.each {|member| member.save(false)}
    orders.each {|order| order.save!}
  end

  def pickup_date
    file =~ /((\d+)-(\d+))/
    Date.civil 2010, $2.to_i, $3.to_i
  end

  def pickups
    return @pickups if @pickups

    @pickups = location_names.collect do |location|
      pickup = Pickup.new(:name => location, :date => pickup_date, :status => 'archived', :farm => @farm)
      products.each do |product|
        pickup.stock_items << StockItem.new(:product => product)
      end
      pickup
    end
    @pickups
  end

  def headers
    return @headers if @headers
    
    @rows[0].each do |header|
      next unless header
      header.strip!
      header.gsub! 'REG ', 'REGULAR '
      header.gsub! 'LG ', 'LARGE '
      header.gsub! 'Chicken XXL ', 'Chicken, XXL '
      header.gsub! 'New! ', ''
      header.gsub! ' SALE', ''
      header.gsub! 'pound', 'lb'
      header.gsub! ' ml', 'ml'
      header.gsub! '.5/', ".50/"
      header.gsub! ' .5', " 0.5"
      header.gsub! 'oil ', "oil, "
    end

    @headers = @rows[0]
  end

  def product_headers
    headers.select do |header|
      header =~ /(\$)/
    end
  end

  def location_names
    @rows[1..-1].collect {|row| row[7]}.uniq.reject {|name| name.nil? || name == '0'}
  end

  def products
    return @products if @products

    @products = product_headers.collect do |header|
      if header =~ /^(.+?) ?\((.+)\)/
        name = $1
        description = $2
      else
        name = header
        description = nil
      end
      product = Product.find_by_name_and_farm_id name, @farm
      if !product
        product = Product.new(:name => name, :description => description, :farm => @farm)
      end
      product
    end
  end

  def members
    return @members if @members

    @members = []
    @rows[1..-1].each do |row|
      first_name = row[2]
      last_name = row[1]
      next unless first_name && last_name
      next if @members.find {|item| item.first_name == first_name && item.last_name == last_name}

      # Find or create new Member
      member = Member.find_by_first_name_and_last_name first_name, last_name
      if !member
        member = Member.new :first_name => first_name, :last_name => last_name,
                            :email_address => row[3], :phone_number => row[4]
      end
      if !member.subscriptions.detect {|item| item.farm == @farm}
        member.subscriptions << Subscription.new(:farm => @farm)
      end

      @members << member
    end
    @members
  end

  def orders
    @orders ||= @rows[1..-1].collect do |row|
      first_name = row[2]
      last_name = row[1]
      next unless first_name && last_name

      member = members.find {|item| item.first_name == first_name && item.last_name == last_name}

      # Create Order
      pickup = pickups.find {|item| item.name == row[7]}
      begin
        timestamp = DateTime.parse(row[0])
      rescue Exception => e
        timestamp = pickup.date # If timestamp is 'manual' or nil use pickup date
      end
      Order.new :pickup => pickup, :member => member, :created_at => timestamp
    end.reject {|item| item.nil?}
  end

end