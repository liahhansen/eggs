class DeliveryExporter < ActiveRecord::Base
  def self.get_csv(delivery, tabs = false)
    # headers: last name, first name, email, cell, location, stock_item, notes, balance, bag total, new balance, how paid, last_name

    col_sep = tabs ? "\t" : ","

    csv_string = FasterCSV.generate(:col_sep => col_sep) do |csv|

      csv << "#{delivery.pretty_date} - #{delivery.name}"

      delivery.locations.each do |location|
        csv << ["#{location.name} - #{location.host_name}", location.address, "#{location.host_email} - #{location.host_phone}"]
      end

      headers = ["Last Name", "First Name", "Email", "Cell Phone", "Location"]
      delivery.stock_items.each {|item| headers << "#{item.product_name} - #{item.product_price_code}"}
      headers += ["Notes", "Balance", "Bag Total", "New Balance", "How Paid", "Last Name"]

      csv << headers

      totals = [' ',' ',' ',' ',' ',]
      delivery.stock_items.each {|item| totals << item.quantity_ordered}
      csv << totals

      # rows
      delivery.orders.each do |order|
        sub = order.member.subscriptions.select{|item| item.farm.name = order.delivery.farm.name}.first
        row = [order.member.last_name, order.member.first_name, order.member.email_address, order.member.phone_number, order.location.name]
        order.order_items.each{ |item| row << item.quantity }
        row += [order.notes, sub.current_balance, order.finalized_total, sub.current_balance, nil, order.member.last_name]
        csv << row
      end
      
    end
  end
end
