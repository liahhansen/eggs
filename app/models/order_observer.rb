class OrderObserver < ActiveRecord::Observer
  def after_save(order)
    if order.notes && order.notes != ""
      #Notifier.deliver_order_notes_notification(order)
    end
  end
end
