Feature: Manage deliveries
  In order to manage a CSA
  I want to create and manage deliveries

Background:
  Given I am logged in as an admin
  When I follow "Soul Food Farm"
  And I follow "Emeryville"
  Then I should see "delivery: Emeryville"

Scenario: Create A Delivery
  Given I am at Soul Food Farm
  Then I should see "add new delivery"
  When I follow "add new delivery"
  Then I should see "Minimum order total"
  And I should see "Select Locations:"
  And I should see "SF / Potrero"
  And I should not see "Someone's House"
  When I fill in the following:
    |delivery[date]|3/5/2010|
    |delivery_name|Hayes Valley|
  And I check "location_0"
  And I press "Create"
  Then I should see "Delivery was successfully created"



Scenario: Entering Finalized Totals
  When I follow "Enter Finalized Totals"
  Then I should see "Finalized Total"
  When I fill in the following:
    |delivery_orders_attributes_0_finalized_total|11.11|
    |delivery_orders_attributes_1_finalized_total|22.22|
    |delivery_orders_attributes_2_finalized_total|33.33|
  And I press "Update"
  Then I should see "Delivery was successfully updated"
  And I should see "Enter Finalized Totals"
