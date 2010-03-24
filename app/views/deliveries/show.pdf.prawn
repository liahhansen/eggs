pdf.define_grid(:columns => 2, :rows => 5, :column_gutter => 10)
pdf.font "Helvetica"
pdf.font_size 12
pdf.stroke_color 'cccccc'


def render_label(pdf, label)
    pdf.indent 8 do
    pdf.move_down 8
    pdf.font "Helvetica", :style => :bold do
      pdf.text "#{label.order.member.last_name}, #{label.order.member.first_name} - #{label.order.location.name}", :size => 13
      pdf.text "#{label.order.member.phone_number}", :size => 13
    end
    label.order_items.each do |item|
      if item.quantity != 0
        pdf.text "#{item.quantity} x #{item.stock_item.product_name} - #{item.stock_item.product_price_code}", :size => 12
      end
    end
    pdf.move_cursor_to(18)
    if label.total_labels == 1
      pdf.text "Prv. Acct Balance: #{number_to_currency label.order.member.balance_for_farm(@farm)} Bag Total: _________"
    else
      if label.total_labels == label.label_num
        pdf.text "Prv. Acct Balance: #{number_to_currency label.order.member.balance_for_farm(@farm)} Bag Total: ____________  Label #{label.label_num} of #{label.total_labels}"
      else
        pdf.text "Label #{label.label_num} of #{label.total_labels}"
      end
    end

  end
end

def render_page(pdf, labels)
  label_num = 0
  pdf.grid.rows.times do |row|
    pdf.grid.columns.times do |col|
      box = pdf.grid(row,col)
      pdf.bounding_box box.top_left, :width => box.width, :height => box.height do
        if(labels[label_num] != nil)
          render_label pdf, labels[label_num]
          label_num += 1
          pdf.stroke { pdf.rectangle(pdf.bounds.top_left, box.width,box.height)}
        end
      end
    end
  end
end

label_maker = LabelMaker.new
labels = label_maker.get_labels_from_delivery @delivery

num_pages = (labels.size.to_f / 10).ceil

(1..num_pages).each do |page_num|
  render_page pdf, labels[(page_num-1)*10...(10*page_num)]
  pdf.start_new_page unless page_num == num_pages
end

