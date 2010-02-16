class Importer

  def initialize(dir = "#{RAILS_ROOT}/db/import")
    @dir = dir
  end

  def pickups
    importers.collect(&:pickups).flatten
  end

  def import!
    importers.collect do |importer|
      importer.import!
      importer.pickups
    end.flatten
  end

  private

  def importers
    Dir["#{@dir}/*.csv"].collect {|file|  PickupImporter.new file}
  end

end

class PickupImporter
  attr_reader :file, :rows, :farm

  def initialize(file)
    @file = file
    @rows = CSV.read file
    @farm = Farm.find_by_name('Soul Food Farm') || raise("Unable to find farm with name 'Soul Food Farm'")
  end

  def import!
    pickups.each {|pickup| pickup.save!}
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
      header.gsub! 'Chicken XXL ', 'Chicken, XXL '
      header.gsub! 'New! ', ''
    end

    @headers = @rows[0]
  end

  def product_headers
    headers.select do |header|
      header =~ /(\$)/
    end
  end

  def location_names
    @rows[1..-1].collect {|row| row[7]}.uniq.reject {|name| name.nil?}
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
end