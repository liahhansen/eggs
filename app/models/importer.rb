class Importer

  def initialize(dir = "#{RAILS_ROOT}/db/import")
    @dir = dir
  end

  def pickups
    Dir["#{@dir}/*.csv"].collect {|file|  PickupImporter.new file}
  end

end

class PickupImporter
  attr_reader :file, :rows

  def initialize(file)
    @file = file
    @rows = CSV.read file
  end

  def pickup_date
    file =~ /((\d+)-(\d+))/
    Date.civil 2010, $2.to_i, $3.to_i
  end

  def headers
    return @headers if @headers
    
    @rows[0].each do |header|
      next unless header
      header.gsub! 'REG ', 'REGULAR '
      header.gsub! 'Chicken XXL ', 'Chicken, XXL '
      header.gsub! 'New! ', ''
    end

    @headers = @rows[0]
  end

  def products
    @products ||= headers.select do |header|
      header =~ /(\$)/
    end
  end
end