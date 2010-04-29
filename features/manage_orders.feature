Feature: Manage Orders
  As a CSA Manager
  In order to manage a delivery
  I should be able to submit an order for a farm's member

Background:
  Given I am the registered admin user jennyjones@kathrynaaker.com
  Given there is a "open" delivery "Emeryville"
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"
  When I follow "Soul Food Farm"
  Then I should see "Open (currently accepting orders)"

Scenario: Add a new order as an admin
  When I follow "Emeryville"
  Then I should see "add order"
  When I follow "add order"
  Then I should see "New Order"
  And I should see "Smith, Suzy"
  And I should see "Brown, Ben"
  When I select "2" from "order_order_items_attributes_0_quantity"
  And I press "Submit"
  Then I should see "Order was successfully created."
  
Scenario: Delete an order as an admin
  When I follow "Emeryville"
  Then I should see "Brown, Ben"
  When I follow "Brown, Ben"
  Then I should see "Delete Order"
  When I follow "Delete Order"
  Then I should not see "Brown, Ben"