Feature: Add a new ticket
  As a User
  I want to be able open a new ticket
  So that I can request a needed service

Background: tickets in system
  Given I am logged on as an "admin"
  And I am on the admin home page  
  

Scenario: add ticket
  When an "IT" service provider exists 
  Then I should see "New Ticket"  
  When I follow "New Ticket"
  Then I should be on the New Ticket page
  When I select "IT" from "Department"
  And I fill in "Title" with "Broken Computer"
  And I press "Submit Ticket"
  #Then I should be on the admin home page
  And I should see "Broken Computer"

Scenario: add ticket without a description
  When an "IT" service provider exists 
  Then I should see "New Ticket"  
  When I follow "New Ticket"
  Then I should be on the New Ticket page  
  When I press "Submit Ticket"
  Then I should be on the New Ticket page
  And I should see "Incomplete Ticket"
  
Scenario: add a ticket for a department without a service provider
  Then I should see "New Ticket"  
  When I follow "New Ticket"
  Then I should be on the New Ticket page
  When I select "IT" from "Department"
  And I fill in "Title" with "Broken Computer"
  And I press "Submit Ticket"
  Then I should be on the My Tickets page
  And I should see "Error: No Provider could be located for this ticket"
  
