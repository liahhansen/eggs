Feature: Manage Pickups
  In order to manage a CSA
  I want to create and manage pickups

Background:
  Given I am the registered user jennyjones
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"  

Scenario: list Pickups
  When I go to farms
  And I follow "Soul Food Farm"
  And I follow "Pickups:"
  Then I should see "Hayes Valley"
  And I should not see "Marin"
  
Scenario: View Pickup Details
  When I go to farms
  And I follow "Soul Food Farm"
  And I follow "Emeryville - 2010-02-03"
  Then I should see "Pickup: Emeryville"
  And I should see "Feb 3, 2010"
  And I should see "Status: OPEN"

  
