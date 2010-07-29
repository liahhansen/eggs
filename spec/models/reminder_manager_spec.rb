require 'spec_helper'

describe ReminderManager do

  before(:each) do

    @farm = Factory(:farm_with_members, :reminders_enabled => true)
    3.times do
      @farm.deliveries << Factory(:delivery, :farm => @farm, :status => "open",
                                  :date => Time.now + 13.days,
                                  :created_at => Time.now - 20.days)
    end
    
    @reminder_manager = ReminderManager.new

    Factory.create(:email_template, :identifier => "order_reminder", :farm => @farm)
    Factory.create(:email_template, :identifier => "order_reminder_last_call", :farm => @farm)

  end

  it "should be able to schedule new reminders for a delivery" do
    DeliveryOrderReminder.count.should == 0
    @farm.deliveries.each do |delivery|
      @reminder_manager.schedule_reminders_for_delivery(delivery)
      reminders = DeliveryOrderReminder.find_all_by_delivery_id(delivery.id)
      reminders.size.should == 2
      reminders.first.deliver_at == delivery.date - 6.days
      reminders.last.deliver_at == delivery.date - 14.days
      reminders.first.deliver_at.hour.should == 7
      reminders.last.deliver_at.hour.should == 7
    end
  end

  it "should not schedule reminders if reminders_enabled is false" do
    @farm.update_attribute(:reminders_enabled, false)
    @reminder_manager.schedule_reminders_for_delivery(@farm.deliveries.first)
    DeliveryOrderReminder.count.should == 0
  end

    
  it "should retrieve any reminders that are ready to be sent" do
    @reminder_manager.schedule_reminders_for_delivery(@farm.deliveries.first)
    ready_reminders = @reminder_manager.get_ready_reminders
    ready_reminders.size.should == 1
    DeliveryOrderReminder.count.should == 2
  end
    
  it "should delete reminder after sending" do
    @reminder_manager.schedule_reminders_for_delivery(@farm.deliveries.first)
    @reminder_manager.get_ready_reminders.size.should == 1
    @reminder_manager.deliver_ready_reminders

    @reminder_manager.get_ready_reminders.size.should == 0
    DeliveryOrderReminder.count.should == 1
  end

  it "should filter out members with existing orders for that delivery" do
    delivery = @farm.deliveries.first
    member = @farm.members.first

    @reminder_manager.schedule_reminders_for_delivery(delivery)
    delivery.orders << Factory(:order_with_items,
                               :delivery => delivery,
                               :member => member)

    member_size = @farm.members.size

    @reminder_manager.get_members_without_orders(delivery).size.should == member_size - 1

  end

  

end
