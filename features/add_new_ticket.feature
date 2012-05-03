Feature: Add a new ticket
  As a User
  I want to be able open a new ticket
  So that I can request a needed service

Background: Locations, Service Areas and Forms exist
  Given an active location named "Main Office" exists
  And an active service area named "IT" exists
  And a form with the title "Fix Me" for "IT" exists
  And I am logged on as an "admin"
  And I am on the admin home page  
  

Scenario: add ticket  
  Then I should see "New Ticket"  
  When I follow "New Ticket"
  Then I should be on the New Ticket page
  When I select "Main Office" from "Location"
  And I select "IT" from "Service Area"
  And I select "Fix Me" from "Ticket Type"
  And I press "Next"
  Then I should be on the Continue New Ticket page
  And I should see "New IT Ticket at Main Office"
  And I should see "Fix Me"
  And I fill in "Title" with "Broken Computer"
  And I press "Create Ticket"  
  And I should see "Service Area: IT"
  And I should see "Location: Main Office"
  And I should see "Title: Broken Computer"

  
Scenario: try to create a ticket without selecting a location
  Then I should see "New Ticket"  
  When I follow "New Ticket"
  Then I should be on the New Ticket page  
  When I select "IT" from "Service Area"
  And I select "Fix Me" from "Ticket Type"
  And I press "Next"
  Then I should be on the New Ticket page
  And I should see "Please Select A Location"
  
Scenario: try to create a ticket without selecting a service area
  Then I should see "New Ticket"  
  When I follow "New Ticket"
  Then I should be on the New Ticket page
  When I select "Main Office" from "Location"  
  And I select "Fix Me" from "Ticket Type"
  And I press "Next"
  Then I should be on the New Ticket page
  And I should see "Please Select A Service Area"
  
Scenario: try to create a ticket without selecting a type
  Then I should see "New Ticket"  
  When I follow "New Ticket"
  Then I should be on the New Ticket page
  When I select "Main Office" from "Location"
  And I select "IT" from "Service Area"  
  And I press "Next"
  Then I should be on the New Ticket page
  And I should see "Please Select A Ticket Type"

