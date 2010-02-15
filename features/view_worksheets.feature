Feature: View Pickup Worksheet
  In order to manage a CSA pickup
  I want to see a worksheet view of a pickup

Background:
  Given I am the registered user jennyjones
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"
  When I follow "Soul Food Farm"
  And I follow "Emeryville"
  Then I should see "Pickup: Emeryville"

Scenario: View a worksheet
  When I follow "View Worksheet"
  Then I should see "Aaker" 