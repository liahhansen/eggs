Feature: Manage deliveries
  In order to manage a CSA
  I want to create and manage deliveries

Background:
  Given there is a farm "Soul Food Farm"
  Given there is a "inprogress" delivery "Hayes Valley"
  Given there is a "open" delivery "Emeryville"
  Given the "Emeryville" delivery has a date of "2/3/2010"
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"  

Scenario: list deliveries
  When I go to farms
  And I follow "Soul Food Farm"
  Then I should see "Hayes Valley"
  And I should not see "Marin"
  
Scenario: View delivery Details
  When I go to farms
  And I follow "Soul Food Farm"
  And I follow "Emeryville"
  Then I should see "Delivery: Emeryville"
  And I should see "Wednesday"
  And I should see "Status: OPEN"

  