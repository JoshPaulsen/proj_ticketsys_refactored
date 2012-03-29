Feature: Edit a user's information
  As an Admin
  I want to be able to set up user permissions and assign roles
  So that I can control who uses the system and how  

Background: tickets in system
  Given a "user" named "Josh" in the "HR" department exists
  And I am logged on as an "admin"
  And I am viewing the user page for "Josh"  
  
Scenario: add ticket
  Then I should see "Edit User"
  And I should see "Department: HR"
  When I follow "Edit User"  
  And I select "IT" from "Department"
  And I press "Update User"
  Then I should see "User Profile Updated"
  And I should see "Department: IT"  
  