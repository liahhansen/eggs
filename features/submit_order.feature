Feature: Submit Order
  In order for customers to create orders
  They have to submit an order form

Background:
  Given I am the registered user benbrown@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should see "Welcome"  

Scenario: View Order Form
  When I go to home
  Then I should see "Mission / Potrero"
  And I follow "Mission / Potrero"
  Then I should see "New Order"
  And I should see "Mission / Potrero - Wednesday"
  And I should see "Chicken, REGULAR"
  And I should see "Eggs"

Scenario: Submit Order Form With Minimum Order Error
  When I go to home
  And I follow "Mission / Potrero"
  Then I should see "New Order"
  And I select "1" from "order_order_items_attributes_1_quantity"
  And I press "Create"
  Then I should see "your order does not meet the minimum"

Scenario: Submit Order Form with Success
  When I go to home
  And I follow "Mission / Potrero"
  Then I should see "New Order"
  And I select "2" from "order_order_items_attributes_0_quantity"
  And I press "Create"
  Then I should see "Order was successfully created."
  
Scenario: Edit an Order
  When I go to home
  And I follow "edit order"
  Then I should see "Emeryville"