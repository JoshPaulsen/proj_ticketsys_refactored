Feature: Add/Remove a related user to a ticket
  As a user/service provider
  I want to be able to add related users to a ticket
  So that I can notify other people who want to be privy to the ticket info

Background: tickets in system
  Given I am signed in as an "admin"
  And I have an "IT" ticket with the title "Test"
  And a "user" named "Joe" exists
  And an "IT" service provider named "Josh" exists
  And I am viewing the "Test" ticket
  
Scenario: add an additional user
  When I select "Joe" from "add_user_id"
  And I press "Add Additional User"
  Then I should see "Additional User Added to Ticket"
  And I should see "Additional Users: Joe"
  
Scenario: add an invalid user  
  When I press "Add Additional User"
  Then I should see "Please select a user first"
  
Scenario: remove a user
  When I select "Joe" from "add_user_id"
  And I press "Add Additional User"
  Then I should see "Additional User Added to Ticket"
  And I should see "Additional Users: Joe"
  When I select "Joe" from "rm_user_id"
  And I press "Remove Additional User"
  Then I should see "Joe was removed from the ticket"
  
Scenario: add an additional provider
  When I select "Josh" from "add_prov_id"
  And I press "Add Additional Provider"
  Then I should see "Additional Provider Added to Ticket"
  And I should see "Additional Providers: Josh"
  
Scenario: remove an additional provider
  When I select "Josh" from "add_prov_id"
  And I press "Add Additional Provider"
  Then I should see "Additional Provider Added to Ticket"
  When I select "Josh" from "rm_prov_id"
  And I press "Remove Additional Provider"
  Then I should see "Josh was removed from the ticket"

Scenario: add an invalid additional provider  
  When I press "Add Additional Provider"
  Then I should see "Please select a provider first"  

Scenario: add an additional user who is already attached to the ticket
  When I select "Josh" from "add_prov_id"
  And I press "Add Additional Provider"
  Then I should see "Additional Provider Added to Ticket"
  When I select "Josh" from "add_user_id"
  And I press "Add Additional User"
  Then I should see "That person is already attached to this ticket"  

Scenario: add an additional provider who is already attached to the ticket
  When I select "Josh" from "add_prov_id"
  And I press "Add Additional Provider"
  Then I should see "Additional Provider Added to Ticket"
  When I select "Josh" from "add_prov_id"
  And I press "Add Additional Provider"
  Then I should see "That person is already attached to this ticket"  
