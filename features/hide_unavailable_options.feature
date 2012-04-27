Feature: Hide options unavailable to users
  As an admin
  I want to hide options from users who are not permitted to access them
  So that users do not get confused

Background:

Scenario: as a user on the main page I should not see things that I have no permission for
  Given I am logged in as a "user"
  And I am on the main page
  Then I should not see "Users"
  And I should not see "Settings"
  Given there is an IT ticket "Fix me" created by "Joe" belonging to "Bob"
  Then I should not see "Fix me"

Scenario: as a service provider on the main page I should not see things that I have no permission for
  Given I am logged in as an "service provider" in IT
  And I am on the main page
  And there is an HR ticket "Fix me" created by "Joe" belonging to "Bob"
  Then I should not see "Fix me"

Scenario: as a user viewing a ticket I should not see things that I have no permission for
  Given I am logged in as a "user"
  And I am viewing a ticket
  Then I should not see "Add Additional Provider"
  And I should not see "Remove Additional Provider"
  And I should not see "Delete Ticket"

Scenario: as a service provider viewing a ticket I should not see things that I have no permission for
  Given I am logged in as a "service provider"
  And I am viewing a ticket
  Then I should not see "Delete Ticket"

Scenario: as a user viewing my profile I should not see things that I have no permission for
  Given I am logged in as a "user"
  And I am viewing my profile
  Then I should not see "Deactivate User"

Scenario: as a service provider viewing my profile I should not see things that I have no permission for
  Given I am logged in as a "service provider"
  And I am viewing my profile
  Then I should not see "Deactivate User"

Scenario: as a service provider viewing settings I should not see things that I have no permission for
  Given I am logged in as a "service provider"
  And I am on the "Settings" page
  Then I should not see "Service Area Settings"
  And I should not see "Location Settings"
