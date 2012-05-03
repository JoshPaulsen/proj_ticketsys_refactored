Feature: Edit a user's information
  As an Admin
  I want to be able to set up user permissions and assign roles
  So that I can control who uses the system and how  

Background: tickets in system
  Given a "user" named "Josh" with the email "josh@josh.com" exists
  And an active service area named "IT" exists
  And I am logged on as an "admin"
  And I am viewing the user page for "Josh"  
  
Scenario: edit the email and name  
  And I should see "Name: Josh"
  And I should see "Email: josh@josh.com"
  When I press "Edit User"  
  And I fill in "Email" with "different@d.com"
  And I fill in "First Name" with "diff"
  And I press "Update User"
  Then I should see "User Profile Updated"
  And I should see "Name: diff"
  And I should see "Email: different@d.com"

Scenario: edit the privilege  
  And I should see "Privilege: user"
  When I press "Edit User"  
  And I select "admin" from "Privilege"
  And I press "Update User"
  Then I should see "User Profile Updated"
  And I should see "admin"  

 