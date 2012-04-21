Feature: delete a ticket
  As an admin
  I want to be able to delete a ticket
  So that I can remove tickets that were created wrong

Background: tickets in system  
  
  
Scenario: user cannot delete a ticket
  Given I am signed in as a "user"
  And I have a ticket with the title "Fix me"
  When I am viewing the "Fix me" ticket
  Then I should not see "Delete Ticket"
  
Scenario: admin can delete a ticket
  Given I am signed in as a "admin"
  And I have a ticket with the title "Fix me"
  When I am viewing the "Fix me" ticket  
  When I press "Delete Ticket"
  Then I should see "Ticket was deleted"
  
