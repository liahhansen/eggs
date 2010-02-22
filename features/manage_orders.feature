Feature: Manage Orders
  As a CSA Manager
  In order to manage a pickup
  I should be able to submit an order for a farm's member

Background:
  Given I am the registered user jennyjones
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"
  When I follow "Soul Food Farm"
  Then I should see "Open Pickups"

Scenario: Add a new order as an admin
  When I follow "Emeryville"
  Then I should see "add order"
  When I follow "add order"
  Then I should see "New order"
  And I should see "Kathryn Aaker"
  And I should see "Ben Brown"
  When I select "2" from "order_order_items_attributes_0_quantity"
  And I press "Create"
  Then I should see "Order was successfully created."
  
Scenario: Delete an order as an admin
  When I follow "Emeryville"
  Then I should see "Ben Brown"
  When I follow "Ben Brown"
  Then I should see "Delete Order"
