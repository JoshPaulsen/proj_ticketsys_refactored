Feature: Create a new set of questions for a service area
  As an admin/service provider
  I want to be able to create a new questions form 
  So that I can request specific information based on the ticket type

Background: tickets in system
  Given an active service area named "IT" exists
  And I am logged on as an "admin"
  And I am on the service area forms page    

Scenario: create new blank form for IT
  Then I should see "Create a New Blank Form"
  When I select "IT" from "Service Area"
  And I fill in "Enter a ticket type" with "Installation Issue"
  And I press "Create"
  Then I should be viewing the "Installation Issue" form
  And I should see "Ticket Type: Installation Issue"  

Scenario: create new blank form for IT with out a type
  Then I should see "Create a New Blank Form"
  When I select "IT" from "Service Area"
  And I fill in "Enter a ticket type" with ""
  And I press "Create"
  Then I should be on the service area forms page
  And I should see "All Forms Need A Type"  

Scenario: add a field to a form
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the "Installation Issue" form
  Then I should see a button that says "Add New Field"
  When I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "What to install?"
  And I choose "field_type_text"
  And I press "Add New Field"
  Then I should be viewing the "Installation Issue" form
  And I should see "What to install?" 
  
Scenario: add a field to a form with out a question
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with ""
  And I choose "field_type_text"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "All Forms Fields Need A Question" 
  
Scenario: add a text field to a form with an option
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Options"
  And I choose "field_type_text"
  And I fill in "options_option_1" with "bananas"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "A Text Field Does Not Need Options" 
  
Scenario: add a radio button field to a form
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the "Installation Issue" form
  Then I should see a button that says "Add New Field"
  When I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Pick one of these"
  And I choose "field_type_radio"
  When I fill in "options_option_1" with "apples"
  And I fill in "options_option_2" with "bananas"
  And I fill in "options_option_3" with "croutons"
  And I press "Add New Field"
  Then I should be viewing the "Installation Issue" form
  And I should see "Pick one of these" 
  And I should see "apples" 
  And I should see "bananas" 
  And I should see "croutons" 
  
Scenario: add a radio button field with only one selection
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Pick one"
  And I choose "field_type_radio"
  And I fill in "options_option_1" with "one"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "A Radio Button Field Needs At Least Two Options" 
  
  
Scenario: add a select field to a form
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the "Installation Issue" form
  Then I should see a button that says "Add New Field"
  When I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Pick one of these"
  And I choose "field_type_select"
  When I fill in "options_option_1" with "apples"
  And I fill in "options_option_2" with "bananas"
  And I fill in "options_option_3" with "croutons"
  And I press "Add New Field"
  Then I should be viewing the "Installation Issue" form
  And I should see "Pick one of these" 
  And I select "apples" from "Pick one of these" 
  And I select "bananas" from "Pick one of these" 
  And I select "croutons" from "Pick one of these" 
  
Scenario: add a select field with only one selection
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Pick one"
  And I choose "field_type_select"
  And I fill in "options_option_1" with "one"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "A Select Field Needs At Least Two Options" 

Scenario: add a check box field to a form
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the "Installation Issue" form
  Then I should see a button that says "Add New Field"
  When I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "What to install?"
  And I choose "field_type_check_box"
  And I press "Add New Field"
  Then I should be viewing the "Installation Issue" form
  And I should see "What to install?" 
  
Scenario: add a check box field to a form with an option
  Given a form with the title "Installation Issue" for "IT" exists
  And I am viewing the new field page for the "Installation Issue" form
  And I should see "Please enter your question"
  When I fill in "Please enter your question" with "Options"
  And I choose "field_type_check_box"
  And I fill in "options_option_1" with "bananas"
  And I press "Add New Field"
  Then I should be viewing the new field page for the "Installation Issue" form
  And I should see "A Check Box Field Does Not Need Options" 
  
