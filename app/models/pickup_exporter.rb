class PickupExporter < ActiveRecord::Base
  def self.get_csv(pickup)
    # headers: last name, first name, email, cell, stock_item, notes, balance, bag total, new balance, how paid, last_name

    csv_string = FasterCSV.generate do |csv|

      headers = ["Last Name", "First Name", "Email", "Cell Phone"]
      pickup.stock_items.each {|item| headers << item.product_name}
      headers += ["Notes", "Balance", "Bag Total", "New Balance", "How Paid", "Last Name"]

      csv << headers

      # rows
      pickup.orders.each do |order|
        row = [order.member.last_name, order.member.first_name, order.member.email_address, order.member.phone_number]
        order.order_items.each{ |item| row << item.quantity }
        row += [order.notes, order.member.balance, order.finalized_total, order.member.balance, "", order.member.last_name]
        csv << row
      end
      
    end
  end
end
