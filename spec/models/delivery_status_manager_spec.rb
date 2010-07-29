require "spec_helper"

require 'benchmark'


describe DeliveryStatusManager do

  before(:each) do

    Factory(:delivery, :status => 'notyetopen', :opening_at => DateTime.now - 10.minutes)
    Factory(:delivery, :status => 'notyetopen', :opening_at => DateTime.now + 10.minutes)
    Factory(:delivery, :status => 'notyetopen', :opening_at => DateTime.now - 10.minutes, :status_override => true)

    Factory(:delivery, :status => 'open', :closing_at => DateTime.now - 10.minutes)
    Factory(:delivery, :status => 'open', :closing_at => DateTime.now + 10.minutes)
    Factory(:delivery, :status => 'open', :closing_at => DateTime.now - 10.minutes, :status_override => true)

    Factory(:delivery, :status => 'finalized', :date => DateTime.now - 1.day)
    Factory(:delivery, :status => 'finalized', :date => DateTime.now)
    Factory(:delivery, :status => 'finalized', :date => DateTime.now + 1.day)
    Factory(:delivery, :status => 'finalized', :date => DateTime.now - 1.day, :status_override => true)

    Factory(:delivery, :status => 'inprogress', :deductions_complete => false, :finalized_totals => true)
    Factory(:delivery, :status => 'inprogress', :deductions_complete => true, :finalized_totals => true)

  end
  
  it "should update statuses" do

    DeliveryStatusManager.get_deliveries_by_status('finalized').size.should == 3
    DeliveryStatusManager.get_deliveries_by_status('open').size.should == 2
    DeliveryStatusManager.get_deliveries_by_status('notyetopen').size.should == 2
    DeliveryStatusManager.get_deliveries_by_status('inprogress').size.should == 2
    DeliveryStatusManager.get_deliveries_by_status('archived').size.should == 0

    DeliveryStatusManager.update_statuses

    DeliveryStatusManager.get_deliveries_by_status('finalized').size.should == 3
    DeliveryStatusManager.get_deliveries_by_status('open').size.should == 2
    DeliveryStatusManager.get_deliveries_by_status('notyetopen').size.should == 1
    DeliveryStatusManager.get_deliveries_by_status('inprogress').size.should == 2
    DeliveryStatusManager.get_deliveries_by_status('archived').size.should == 1

    
    

  end
end