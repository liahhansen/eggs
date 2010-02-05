Feature: Login and Logout
  In order to secure private information
  I need to be able to only view data when logged in

Scenario: Logging in and out
  Given I am the registered user jennyjones
  And I am on login
  When I login with valid credentials
  Then I should see "Soul Food Farm"
  And I follow "Log out"
  And I go to farms
  Then I should see "You must log in to access this page"

  