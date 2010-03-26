Feature: Manage deliveries
  In order to manage a CSA
  I want to create and manage deliveries

Background:
  Given I am the registered user jenny@example.com
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
  Then I should see "delivery: Emeryville"
  And I should see "Feb 3, 2010"
  And I should see "Status: OPEN"

  
