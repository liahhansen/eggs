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
      delivery.stock_items.with_quantity.each {|item| headers << "#{item.product_name} - #{item.product_price_code}"}
      delivery.delivery_questions.visible.each {|question| headers << question.short_code }
      headers += ["Notes", "Estimated Total", "Bag Total", "Balance", "How Paid", "Last Name"]

      csv << headers

      totals = [' ',' ',' ',' ',' ',]
      delivery.stock_items.with_quantity.each {|item| totals << item.quantity_ordered}
      csv << totals

      # rows
      delivery.orders.each do |order|
        sub = order.member.subscriptions.select{|item| item.farm.name = order.delivery.farm.name}.first
        row = [order.member.last_name, order.member.first_name, order.member.email_address, order.member.phone_number, order.location.name]
        order.order_items.with_stock_quantity.each{ |item| row << item.quantity }
        order.order_questions.visible.each {|question| row << question.option_code }
        row += [order.notes, order.estimated_total, order.finalized_total, sub.current_balance, nil, order.member.last_name]
        csv << row
      end
      
    end
  end

  def self.get_xls(delivery)
    csv_str = self.get_csv(delivery)

    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet :name => "#{delivery.name} - #{delivery.pretty_date}"

    csv_rows = FasterCSV.parse(csv_str)

    csv_rows.each_with_index do |row, i|
      row.each_with_index do |field, j|
        sheet.row(i).push field
      end
    end

    return book

  end
end
