Feature: Manage Members
  In order to manage a CSA delivery
  I want to be able to veiw and manage members

Background:
  Given there is a farm "Soul Food Farm"
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"
  When I follow "Soul Food Farm"
  Then I should see "Manage Members"

Scenario: View list of members
  Given the farm has the member "Billy Bobbins"
  When I follow "Manage Members"
  Then I should see "Bobbins"
  And I should see "Soul Food Farm"  