Feature: Create Locations
  As a manager
  In order to schedule deliveries
  I need to be able to create locations for a particular farm

Background:
  Given there is a farm "Soul Food Farm"
  Given I am logged in as an admin

Scenario: View location Index
  Given the farm has a location "Soul Food Farm" with host "Alexis"
  Given I am at Soul Food Farm
  Then I should see "Manage Locations"
  When I follow "Manage Locations"
  Then I should see "Pickup Locations"
  And I should see "Alexis"
  And I should not see "Julia Childs"
  
Scenario: Create a new location
  Given I am at Soul Food Farm
  When I follow "Manage Locations"
  And I follow "Create New Location"
  And I fill in the form with a location
  And I press "Create"
  Then I should see "Pickup Locations"

