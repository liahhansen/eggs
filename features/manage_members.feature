Feature: Manage Members
  In order to manage a CSA delivery
  I want to be able to veiw and manage members

Background:
  Given there is a farm
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should see "Farms"
  When I follow "Soul Food Farm"
  Then I should see "Manage Members"

Scenario: View list of members
  Given the farm has the member "Billy Bobbins"
  Given the farm has the member "Suzy Smith"
  Given the member "Bobbins" is pending
  When I follow "Manage Members"
  Then I should see "Bobbins (pending)"
  And I should see "Soul Food Farm"
  And I should see "Smith"
  And I should not see "Smith (pending)"

Scenario: Add transaction for member through details page
  Given the farm has the member "Suzy Smith"
  When I follow "Manage Members"
  Then I should see "Smith"
  When I follow "Smith"
  Then I should see "Add Transaction"
  When I follow "Add Transaction"
  Then I should see "Current Balance: $0.00"
  Then "credit" should be selected for "transaction_debit"