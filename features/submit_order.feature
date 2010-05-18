Feature: Submit Order
  In order for customers to create orders
  They have to submit an order form

Background:
  Given there is a farm
  Given I am the registered member user benbrown@kathrynaaker.com
  Given there is a "open" delivery "Mission / Potrero"
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
  Given the delivery has a minimum total of 40
  When I go to home
  And I follow "Mission / Potrero"
  Then I should see "New Order"
  And I select "1" from "order_order_items_attributes_2_quantity"
  And I press "Submit"
  Then I should see "your order does not meet the minimum"

Scenario: Submit Order Form with Success
  Given the delivery has a minimum total of 40  
  When I go to home
  And I follow "Mission / Potrero"
  Then I should see "New Order"
  And I select "2" from "order_order_items_attributes_0_quantity"
  And I press "Submit"
  Then I should see "Order was successfully created."
  And "benbrown@kathrynaaker.com" should receive an email
  

#Scenario: Submit order with a delivery question
#  pending
#  Given there is a delivery question "Our policy is to provide fresh" with options OK with frozen | OK\\nOK to substitute 1 for frozen | 1
#  When I go to home
#  And I follow "Mission / Potrero"
#  Then I should see "Our policy is to provide fresh"
#  And I should see "OK with frozen"
#  And I should see "OK to substitute"
#  When I select "OK with frozen" from "order_order_questions_attributes_0_option_code"
#  And I select "2" from "order_order_items_attributes_0_quantity"
#  And I press "Submit"
#  Then I should see "OK to substitute 1 for frozen"
#  And I should see "Order was successfully created."
  
Scenario: Edit an Order
  Given I have an existing order for the "Mission / Potrero" delivery
  When I go to home
  Then I should see "view/edit order"
  And I follow "view/edit order"
  Then I should see "Mission / Potrero"