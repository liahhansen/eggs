Feature: Manage Pickups
  In order to manage a CSA
  I want to create and manage pickups

Background:
  Given I am the registered user jennyjones
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"
  When I follow "Soul Food Farm"
  And I follow "Emeryville"
  Then I should see "Pickup: Emeryville"

Scenario: Entering Finalized Totals
  When I follow "Enter Finalized Totals"
  Then I should see "Finalized Total"
  When I fill in the following:
    |pickup_orders_attributes_0_finalized_total|11.11|
    |pickup_orders_attributes_1_finalized_total|22.22|
    |pickup_orders_attributes_2_finalized_total|33.33|
  And I press "Update"
  Then I should see "Pickup was successfully updated"
  And I should see "Enter Finalized Totals"
