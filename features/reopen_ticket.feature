Feature: Reopen a ticket
  As a user/service provider
  I want to be able to reopen an old ticket
  So that one can revisit and fix a potentially unfinished request

Background: there is an admin account
  Given I am logged on as an "admin"
  And I have a closed ticket with the title "Broken Stapler"
  And I am viewing the "Broken Stapler" ticket

Scenario: reopen the ticket
  Then I should see "Broken Stapler"
  And I should see "Closed"
  And I should not see "Add a New Note"
  When I press "Reopen Ticket"
  #Then I should see "Are you sure"
  #And I press "OK"
  Then I should be viewing the "Broken Stapler" ticket
  And I should see "Broken Stapler"  
  And I should not see "Closed"
  And I should see "Add a New Note"
  
