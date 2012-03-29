Feature: Add/Remove a related user to a ticket
  As a user/service provider
  I want to be able to add related users to a ticket
  So that I can notify other people who want to be privy to the ticket info

Background: tickets in system
  Given I am signed in as a "user"
  And I have a ticket with the title "Test"
  And a "user" named "Josh" with the email "t@t.com" exists
  And a "user" named "Joe" with an email "j@j.com" is watching a ticket with the title "Test"
  And I am viewing the "Test" ticket
  
  
Scenario: add a valid user
  Then I should see "Add a watcher to this ticket"
  When I fill in "Email" with "t@t.com"
  And I press "Add Watcher"
  Then I should see "Watcher Added to Ticket"
  And I should see "Watchers: Josh"
  
Scenario: add an invalid user
  Then I should see "Add a watcher to this ticket"
  When I fill in "Email" with "x@x.com"
  And I press "Add Watcher"
  Then I should see "Error: No user with that email exists."
  
Scenario: add an invalid user
  Then I should see "Add a watcher to this ticket"
  When I fill in "Email" with "j@j.com"
  And I press "Add Watcher"
  Then I should see "Error: That person is already watching this ticket"
  
Scenario: remove a valid user
  Then I should see "Remove a watcher from this ticket"
  When I select "Joe" from "Watchers"
  And I press "Remove Watcher"
  Then I should see "Watcher Removed from Ticket"
  And I should not see "Joe"
