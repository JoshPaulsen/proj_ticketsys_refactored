Feature: Attaching files to a note
  As a user/service provider/admin
  I want to be able to attach files to notes
  So that I can better illustrate my problem

Background: there's a ticket
  Given a ticket with the title "Fix me" exists
  And I am logged in as "admin"
  And I am viewing the ticket "Fix me"

Scenario: try to attach a file
  When I fill in "Filename" with "crash.log"
  And I press "Attach file"
  And I fill in the note body with "Log attached:"
  And I press "Add note"
  Then the file "crash.log" should be attached to a note of the ticket "Fix me"
