Feature: Manage Farms
  In order to manage a CSA
  I want to create and manage farms

Scenario: Farms List
  When I go to farms
  Then I should see "Soul Food Farm"
  And I should see "Clark Summit Farm"

Scenario: Creating a new Farm
  When I go to farms
  Then I should see "New farm"
  