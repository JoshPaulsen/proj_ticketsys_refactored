Feature: Modify a ticket
  As a admin/service provider
  I want to be able to correct answers to ticket questions
  So that I can easily refer jobs to better suited providers

Background: tickets in system  

  Given an active location named "Main Office" exists
  And an active service area named "IT" exists
  And a form with the title "Fix Me" for "IT" exists
  And the "Fix Me" form has a text field with the question "Why?"
  And I am logged on as an "admin"
  And I have an "IT" ticket with the title "Broken Computer" using the "Fix Me" form
  And an "IT" service provider named "Billy Joel" exists  
  And I am viewing the "Broken Computer" ticket

Scenario: change the title 
  When I press "Edit Ticket"
  And I fill in "Title" with "Not Broken"
  And I press "Update Ticket"
  Then I should see "Ticket Updated"
  And I should see "Not Broken"  

Scenario: change the title to nothing
  When I press "Edit Ticket"
  And I fill in "Title" with ""
  And I press "Update Ticket"
  Then I should be viewing the edit page for the "Broken Computer" ticket
  Then I should see "Error: The title cannot be blank"   
  
Scenario: change the service provider
  When I press "Edit Ticket"
  And I select "Billy Joel" from "Primary Provider"
  And I press "Set Provider"
  Then I should be viewing the edit page for the "Broken Computer" ticket
  And I should see "Provider Updated"
  
  
  