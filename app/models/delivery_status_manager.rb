class DeliveryStatusManager

  def self.update_statuses
    self.get_deliveries_by_status('finalized').each do |delivery|
      if delivery.date < DateTime.now - 1.day
        delivery.update_attribute('status', 'archived')
      end
    end

    self.get_deliveries_by_status('open').each do |delivery|
      if(delivery.closing_at < DateTime.now)
        delivery.update_attribute('status', 'inprogress')
      end
    end

    self.get_deliveries_by_status('notyetopen').each do |delivery|
      if(delivery.opening_at < DateTime.now)
        delivery.update_attribute('status', 'open')
      end
    end
  end
  
  def self.get_deliveries_by_status(status)
    Delivery.find_all_by_status_and_status_override(status, false)
  end

end