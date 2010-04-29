Feature: Manage Farms
  In order to manage a CSA
  I want to create and manage farms

Background:
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"

Scenario: Farms List
  Given there is a farm "Soul Food Farm"
  Given there is a farm "Clark Summit Farm"
  When I go to farms
  Then I should see "Soul Food Farm"
  And I should see "Clark Summit Farm"

