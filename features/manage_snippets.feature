Feature: Manage Snippet
  In order for managers to show semi-static content
  They must be able to add/edit snippets of text

Background:
  Given I am logged in as an admin
  Given I am on home
  When I follow "Soul Food Farm"
  Then I should see "Manage Snippets"
  When I follow "Manage Snippets"
  Then I should see "snippets"

Scenario: Viewing Snippet List
  Then I should see "snippets"
  And I should not see "Clark Member Homepage Welcome"

Scenario: Viewing a Snippet
  When I follow "show"
  Then I should see "Member Homepage Welcome"
  When I follow "Snippets List"
  Then I should see "snippets"

Scenario: Editing a Snippet
  When I follow "edit"
  Then I should see "Editing snippet"
  When I follow "Back"
  Then I should see "snippets"
  When I follow "edit"
  Then I should see "Editing snippet"
  When I follow "Show"
  Then I should see "Member Homepage Welcome"

Scenario: Updating a Snippet
  When I follow "edit"
  Then I should see "Editing snippet"
  When I press "Submit"
  Then I should see "snippets"

