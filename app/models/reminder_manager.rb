class ReminderManager

  def schedule_reminders_for_delivery(delivery)

    return if (delivery.farm.reminders_enabled == false)

    last_call_email = EmailTemplate.find_by_farm_id_and_identifier(delivery.farm.id, "order_reminder_last_call")
    reminder_email = EmailTemplate.find_by_farm_id_and_identifier(delivery.farm.id, "order_reminder")

    d = delivery.date - 6.days
    #noinspection RubyArgCount
    last_call_datetime = DateTime.new(d.year, d.month, d.day, 7, 0, 0)
    
    d = delivery.date - 14.days
    #noinspection RubyArgCount
    reminder_datetime = DateTime.new(d.year, d.month, d.day, 7, 0, 0)
    
    DeliveryOrderReminder.create!(:delivery_id => delivery.id,
                                  :email_template_id => last_call_email.id,
                                  :deliver_at => last_call_datetime)

    DeliveryOrderReminder.create!(:delivery_id => delivery.id,
                                  :email_template_id => reminder_email.id,
                                  :deliver_at => reminder_datetime)
            
  end

  def get_ready_reminders
    # ready means deliver_at time is between created on and now

    reminders = DeliveryOrderReminder.find(
            :all,
            :conditions => ["deliver_at BETWEEN ? and ?", DateTime.now - 20.days, DateTime.now]
    )

    return reminders

  end

  def deliver_ready_reminders
    reminders = self.get_ready_reminders

    reminders.each do |reminder|
      template = EmailTemplate.find(reminder.email_template_id)

      members = self.get_members_without_orders(reminder.delivery)

      members.each do |member|
        template.deliver_to(member.email_address, :delivery => reminder.delivery)
      end

      Notifier.deliver_admin_notify_reminders_sent(reminder.delivery, template)

      reminder.delete
      
    end
    
  end

  def get_members_without_orders(delivery)

    members = delivery.farm.members

    return [Member.find_by_email_address('kathryn@kathrynaaker.com')] if RAILS_ENV == 'development'


    members.reject do |member|
      # reject if this member has an order for that delivery
      has_order = false
      member.orders.each do |order|
        if(order.delivery == delivery)
          has_order = true
          break
        end
      end
      has_order
    end
  end

end