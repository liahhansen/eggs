Feature: View delivery Worksheet
  In order to manage a CSA delivery
  I want to see a worksheet view of a delivery

Background:
  Given I am the registered admin user jennyjones@kathrynaaker.com
  Given there is a farm "Soul Food Farm"
  Given there is a "open" delivery "Emeryville"
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"
  When I follow "Soul Food Farm"
  And I follow "Emeryville"
  Then I should see "Delivery: Emeryville"

Scenario: View a worksheet
  When I follow "View Worksheet"
  Then I should see "Brown" 