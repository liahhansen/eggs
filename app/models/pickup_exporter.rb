class PickupExporter < ActiveRecord::Base
  def self.get_csv(pickup, tabs = false)
    # headers: last name, first name, email, cell, stock_item, notes, balance, bag total, new balance, how paid, last_name

    col_sep = tabs ? "\t" : ","

    csv_string = FasterCSV.generate(:col_sep => col_sep) do |csv|

      headers = ["Last Name", "First Name", "Email", "Cell Phone"]
      pickup.stock_items.each {|item| headers << "#{item.product_name} - #{item.product_price_code}"}
      headers += ["Notes", "Balance", "Bag Total", "New Balance", "How Paid", "Last Name"]

      csv << headers

      # rows
      pickup.orders.each do |order|
        row = [order.member.last_name, order.member.first_name, order.member.email_address, order.member.phone_number]
        order.order_items.each{ |item| row << item.quantity }
        row += [order.notes, order.member.current_balance(order.pickup.farm), order.finalized_total, order.member.current_balance(order.pickup.farm), "", order.member.last_name]
        csv << row
      end
      
    end
  end
end
