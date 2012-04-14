Feature: Create a new set of questions for a service area
  As an admin/service provider
  I want to be able to create a new questions form 
  So that I can request specific information based on the ticket type

Background: tickets in system
  Given I am logged on as an "admin"
  And I am on the main forms page    

Scenario: create new blank form for IT
  Then I should see "Create a New Blank Form"
  When I fill in "Enter a Ticket Type" with "Installation Issue"
  And I press "Create"
  Then I should be viewing the "Installation Issue" form
  And I should see "Ticket Type: Installation Issue"  

Scenario: create new blank form for IT with out a type
  Then I should see "Create a New Blank Form"
  When I fill in "Enter a Ticket Type" with ""
  And I press "Create"
  Then I should be on the main forms page  
  And I should see "Error: The form must have a type"  

Scenario: add a field to a form
  Given an "IT" form with the ticket type "Installation Issue" exists
  And I am viewing the "Installation Issue" form
  Then I should see "Add a new field to this form"
  When I follow "Add a new field to this form"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "What to install?"
  And I select "Text Field" from "Type"
  And I press "Add New Field"
  Then I should be viewing the "Installation Issue" form
  And I should see "What to install?" 
  
Scenario: add a field to a form with out a question
  Given an "IT" form with the ticket type "Installation Issue" exists  
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with ""
  And I select "Text Field" from "Type"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Error: All forms need a question" 
  
Scenario: add a text field to a form with an option
  Given an "IT" form with the ticket type "Installation Issue" exists  
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Options"
  And I select "Text Field" from "Type"
  And I fill in "1" with "bananas"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Error: A text field does not need options" 
  
Scenario: add a radio button field to a form
  Given an "IT" form with the ticket type "Installation Issue" exists
  And I am viewing the "Installation Issue" form
  Then I should see "Add a new field to this form"
  When I follow "Add a new field to this form"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Pick one of these"
  And I select "Radio Button Field" from "Type"
  When I fill in "1" with "apples"
  And I fill in "2" with "bananas"
  And I fill in "3" with "croutons"
  And I press "Add New Field"
  Then I should be viewing the "Installation Issue" form
  And I should see "Pick one of these" 
  And I should see "apples" 
  And I should see "bananas" 
  And I should see "croutons" 
  
Scenario: add a radio button field with only one selection
  Given an "IT" form with the ticket type "Installation Issue" exists  
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Pick one"
  And I select "Radio Button Field" from "Type"
  And I fill in "1" with "one"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Error: A radio button field needs at least two options" 
  
