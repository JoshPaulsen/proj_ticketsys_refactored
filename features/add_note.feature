Feature: Add a note to a ticket
  As a User
  I want to be able to add notes with optional attachments to my ticket
  So that I can communicate new circumstances

Background: tickets in system
  Given I am logged on as a "user"
  And I have a "Facilities" ticket with the title "Test"
  And I am viewing the "Test" ticket
  
Scenario: add note
  Then I should see "Add a New Note"  
  When I fill in "Add a New Note" with "1-2-3-4-5"
  And I press "New Note"
  Then I should be viewing the "Test" ticket
  And I should see "1-2-3-4-5"
  
Scenario: add ticket
  Then I should see "Add a New Note"    
  When I press "New Note"
  Then I should be viewing the "Test" ticket
  And I should see "Note cannot be blank"
