Feature: Closing a ticket
  As an admin
  I want to be able to close a ticket
  So that I can indicate that the problem has been taken care of

Background: there is an admin account
  Given I am logged on as an "admin"
  And I have a ticket with the title "Broken Stapler"
  And I am viewing the "Broken Stapler" ticket

@javascript
Scenario: close the ticket
  Then I should see "Broken Stapler"
  When I press "Close Ticket"  
  And I confirm popup
  Then I should be on the My Tickets page
  And I should see "Ticket successfully closed"
  And I should see "Broken Stapler"  
  
@javascript
Scenario: start to close the ticket and then change my mind
  When I press "Close Ticket"  
  And I dismiss popup
  And I should be viewing the "Broken Stapler" ticket
  And I should see "Broken Stapler" 


Scenario: closing the ticket should disable adding a note
  Then I should see "Add a New Note"
  When I press "Close Ticket"
  Then I should be on the My Tickets page
  And I should see "Broken Stapler"
  When I follow "View Ticket"
  Then I should be viewing the "Broken Stapler" ticket
  And I should not see "Add a New Note"
