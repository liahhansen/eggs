class Importer

  def initialize(dir, farm)
    @dir = dir
    @farm = farm
  end

  def import!
    imports.collect do |import|
      import.import!
    end
  end

  def imports
    Dir["#{@dir}/*.csv"].collect {|file|  DeliveryImport.new(file, @farm)}
  end

end

class DeliveryImport
  attr_reader :file, :rows, :columns, :farm

  def initialize(file, farm)
    @file = file
    @rows = CSV.read file
    @farm = farm || raise("farm cannot be nil")
    @columns = read_headers @rows[0]
  end

  def import!
    delivery.save! if location_names
    members.each {|member| member.save(false)}
    orders.each {|order| order.save(false)} if location_names
  end

  def delivery_date
    file =~ /((\d+)-(\d+))/
    Date.civil 2010, $2.to_i, $3.to_i
  end

  def find_or_new_location(location_name)
    location = Location.find_by_name_and_farm_id location_name, @farm
    if !location
      location = Location.new(:name => location_name, :farm => @farm,
                              :host_name => '', :host_email => '', :host_phone => '',
                              :address => '',:time_window => '')
      location.save!
    end
    location
  end


  def locations
    location_names.collect {|location_name| find_or_new_location(location_name)}
  end


  def delivery
    return @delivery if @delivery    

    @delivery = Delivery.new(:name => location_names.join(' / '), :date => delivery_date, :status => 'archived', :farm => @farm)
    products.each do |product|
      @delivery.stock_items << StockItem.new(:product => product)
    end

    locations.each do |location|
      @delivery.pickups << Pickup.new(:location => location)
    end

    @delivery
  end

  def normalize_product_header(header)
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

  def headers
    @rows[0]
  end

  def read_headers(row = @rows[0])
    columns = { :products => {} }

    row.each_with_index do |header, index|
      next unless header

      case
        when header =~ /timestamp/i
          columns[:timestamp] = index
        when header =~ /first name/i
          columns[:first_name] = index
        when header =~ /last name/i && !columns[:last_name]
          columns[:last_name] = index
        when header =~ /email/i
          columns[:email] = index
        when header =~ /group email/i
          columns[:alternate_email] = index
        when header =~ /phone|cell/i
          columns[:phone] = index
        when header =~ /where/i
          columns[:location] = index
        when header =~ /neighborhood/i
          columns[:neighborhood] = index
        when header =~ /address/i
          columns[:address] = index
        when header =~ /(\$)/
          normalize_product_header(header)
          columns[:products][find_or_new_product(header)] = index
        when header =~ /questions|notes/i && !columns[:notes]
          columns[:notes] = index
        when header =~ /total/i
          columns[:total] = index
      end
    end

    columns
  end

  def location_names
    return if columns[:location] == nil
    @rows[1..-1].collect {|row| row[columns[:location]]}.uniq.reject {|name|
      name.nil? || name == '0' || name.strip.empty?
    }
  end

  def find_or_new_product(header)
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
      product.save!
    end
    product
  end

  def products
    @products ||= @columns[:products].sort {|a,b| a[1] <=> b[1]}.collect{|pair| pair[0]}
  end

  def members
    return @members if @members

    @members = []
    @rows[1..-1].each do |row|
      first_name = row[columns[:first_name]]
      last_name = row[columns[:last_name]]
      next unless first_name && last_name
      
      first_name = first_name.strip.titleize
      last_name = last_name.strip.titleize
      next if @members.find {|item| item.first_name == first_name && item.last_name == last_name}

      # Find or create new Member
      member = Member.find_by_first_name_and_last_name first_name, last_name
      if !member
        phone_number =  columns[:phone] ? row[columns[:phone]] : ''
        address =       columns[:address] ? row[columns[:address]] : ''
        neighborhood =  columns[:neighborhood] ? row[columns[:neighborhood]] : ''
        alternate_email = columns[:alternate_email] ? row[columns[:alternate_email]] : ''



        member = Member.new :first_name => first_name, :last_name => last_name,
                            :email_address => row[3], :phone_number => phone_number,
                            :address => address, :neighborhood => neighborhood,
                            :alternate_email => alternate_email
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
      first_name = row[columns[:first_name]]
      last_name = row[columns[:last_name]]
      location_name = row[columns[:location]]
      next unless first_name && last_name && location_name

      location = find_or_new_location(location_name)      
      first_name = first_name.strip.titleize
      last_name = last_name.strip.titleize
      member = members.find {|item| item.first_name == first_name && item.last_name == last_name}

      # Create Order
      raise "No delivery found for location '#{location_name}." unless delivery
      begin
        timestamp = DateTime.parse(row[columns[:timestamp]])
      rescue Exception => e
        timestamp = delivery.date # If timestamp is 'manual' or nil use delivery date
      end

      order = Order.new :delivery => delivery, :member => member, :created_at => timestamp,
                        :location => location,
                        :notes => row[columns[:notes]]
      order.finalized_total = row[columns[:total]].gsub('$','').to_f if row[columns[:total]]
      delivery.stock_items.each do |stock_item|
        order.order_items << OrderItem.new(:stock_item => stock_item, :quantity => row[columns[:products][stock_item.product]].to_i || 0)
      end

      order
    end.reject {|item| item.nil?}
  end

end