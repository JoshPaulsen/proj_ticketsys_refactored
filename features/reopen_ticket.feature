Feature: Reopen a ticket
  As a user/service provider
  I want to be able to reopen an old ticket
  So that one can revisit and fix a potentially unfinished request

Background: there is an admin account
  Given I am logged on as an "admin"
  And a closed ticket with the title "Broken Stapler" exists
  And I am viewing the "Broken Stapler" ticket

Scenario: reopen the ticket
  Then I should see "Broken Stapler"
  And I should see "Closed"
  When I press "Reopen This Ticket"
  #Then I should see "Are you sure"
  #And I press "OK"
  Then I should be viewing the "Broken Stapler" ticket
  And I should see "Broken Stapler"  
  And I should not see "Closed"

#Scenario: start to Re-Open the ticket and then change my mind
  #When I press "Reopen This Ticket"
  #Then I should see "Are you sure"
  #And I press "Cancel"
  #Then I should be on the home page
  #And I should not see "Broken Stapler"  
