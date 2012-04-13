Feature: Email Notification
  As a user
  I want to be notified by email when my ticket is updated
  So that I can track its progress

Background: there's a ticket
  Given a ticket with the title "Fix me" was created by "Bob" and is assigned to "admin"

Scenario: ticket closed
  When the ticket "Fix me" is closed
  Then an email should be sent to "Bob"
  And an email should be sent to "admin"

Scenario: ticket reopened
  Given the ticket "Fix me" is closed
  When the ticket "Fix me" is opened
  Then an email should be sent to "Bob"
  And an email should be sent to "admin"

Scenario: note added
  When a note is added to the ticket "Fix me"
  Then an email should be sent to "Bob"
  And an email should be sent to "admin"
