Feature: Modify a ticket
  As a admin/service provider
  I want to be able to correct answers to ticket questions
  So that I can easily refer jobs to better suited providers

Background: tickets in system  
  Given a ticket with the title "Fix me" exists and is assigned to an "IT" service provider named "Rupert"
  And a "Service Provider" in the "IT" service area named "Billy Joel" exists
  And I am logged on as an "admin"
  And I am viewing the "Fix me" ticket
  And I should see "Edit This Ticket"
  
  

Scenario: change the title 
  When I follow "Edit This Ticket"
  And I fill in "Title" with "Not Broken"
  And I press "Update Ticket"
  Then I should see "Ticket Updated"
  And I should see "Not Broken"  

Scenario: change the title to nothing
  When I follow "Edit This Ticket"
  And I fill in "Title" with ""
  And I press "Update Ticket"
  Then I should be viewing the edit page for the "Fix me" ticket
  Then I should see "Error: The title cannot be blank"   
  
Scenario: change the service provider
  When I follow "Edit This Ticket"
  And I select "Billy Joel" from "Service Provider"
  And I press "Update Ticket"
  Then I should be viewing the "Fix me" ticket
  And I should see "Service Provider: Billy Joel"
  
  
  