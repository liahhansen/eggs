pdf.define_grid(:columns => 2, :rows => 5, :column_gutter => 10)
pdf.font "Helvetica"
pdf.font_size 12
pdf.stroke_color 'cccccc'


def render_order(pdf, order)
  if order
    pdf.indent 4 do
      pdf.move_down 4
      pdf.font "Helvetica", :style => :bold do
        pdf.text "#{order.member.last_name}, #{order.member.first_name} - #{order.member.phone_number} - #{@delivery.name}", :size => 12
      end
      order.order_items.each do |item|
        if item.quantity != 0
          pdf.text "#{item.quantity} x #{item.stock_item.product_name} - #{item.stock_item.product_price_code}", :size => 10
        end
      end
      pdf.move_cursor_to(16)
      pdf.text "Bag Total: ____________"
    end
  end
end

def render_page(pdf, order_count)
  pdf.grid.rows.times do |row|
    pdf.grid.columns.times do |col|
      box = pdf.grid(row,col)
      pdf.bounding_box box.top_left, :width => box.width, :height => box.height do
        render_order pdf, @delivery.orders[order_count]
        pdf.stroke { pdf.rectangle(pdf.bounds.top_left, box.width,box.height)}
        order_count += 1
      end
    end
  end
  if order_count % 10 == 0 && @delivery.orders[order_count] != nil
    pdf.start_new_page
    render_page(pdf, order_count)
  end
end

render_page(pdf, 0)
