Feature: logging in
  As an admin
  I want to be able to log in
  So that I can see tickets and administrate the app.

Background: there is an admin account
  Given an "admin" with the password "password" exists
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

Scenario: log in and go back to the login page
  When I fill in "Username" with "admin"
  And I fill in "Password" with "password"
  And I press "Sign in"
  Then I should be on the admin home page
  And I go to the Sign In page
  Then I should be on the admin home page

Scenario: log in and then log out

  When I fill in "Username" with "admin"
  And I fill in "Password" with "password"
  And I press "Sign in"
  Then I should see "Sign out admin"
  When I follow "admin"
  Then I should see "Successfully signed out"
  And I should be on the Sign In page
