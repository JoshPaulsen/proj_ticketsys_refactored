Feature: logging in
  As an admin
  I want to be able to log in
  So that I can see tickets and administrate the app.

Background: there is an admin account
  Given a "admin" user exists with the password "password"
  And I am on the Login page
  #And I am not logged in

Scenario: try to log in with the wrong password
  When I fill in "Username" with "admin"
  And I fill in "Password" with "wrong"
  And I press "Sign in"
  Then I should be on the Sign in page
  And I should see "Invalid Username/Password"

Scenario: try to log in with the right password
  When I fill in "Username" with "admin"
  And I fill in "Password" with "password"
  And I press "Sign in"
  Then I should be on the admin home page
  And I should not see "Invalid Username/Password"  
  And I should see "All Tickets"
