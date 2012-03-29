
# This won't work anymore.  Other related models are affected when a ticket is created.
# If we need to load a bunch of tickets we are going to have to write a more complicated step. 
#When /the following tickets exist/ do |tickets_table|
  #tickets_table.hashes.each do |ticket|
    #Ticket.create!(ticket)
  #end
#end
# Will we evere care about a name?
When /(.*) is logged on as "(.*)"/ do |name, privilege|
  User.create!(:name => name, :privilege => privilege, :password => "123")  
  visit path_to "the home page"
  fill_in("Username:", :with => user.name)
  fill_in("Password:", :with => user.password)
  click_button("Sign in")  
end

Given /^a[n]? "([^"]*)" named "([^"]*)" in the "([^"]*)" department exists$/ do |privilege,name,dep|
  User.create!:name=>name,:password=>name,:privilege=>privilege,:email=>privilege,:department=>dep
end

When /^a[n]? "([^"]*)" with the password "(.*)" exists$/ do |privilege, password|
  User.create!:name=>privilege,:password=>password,:privilege=>privilege,:email=>privilege  
end

When /^a[n]? "([^"]*)" with the email "(.*)" exists$/ do |privilege, email|
  User.create!:name=>email,:password=>email,:privilege=>privilege,:email=>email  
end

When /^a[n]? "([^"]*)" named "([^"]*)" with the email "(.*)" exists$/ do |privilege,name, email|
  User.create!:name=>name,:password=>email,:privilege=>privilege,:email=>email  
end

When /^the user "(.*)" does not exist$/ do |name|
  user = User.find_by_username(name)
  assert user.nil?
end

When /^I am (logged|signed) (o|i)n as a[n]? "(.*)"$/ do |x,y,privilege|
  User.create!(:name => privilege, :privilege => privilege, :password => "123", :email=>"email")
  visit signin_path
  step "I fill in \"Username\" with \"#{privilege}\""
  step "I fill in \"Password\" with \"123\""
  step "I press \"Sign in\""
end

When /^I have a.* "([^"]*)" ticket with the title "([^"]*)"$/ do |department,title|
  step "an \"#{department}\" service provider exists"
  visit new_ticket_path  
  step "I fill in \"Title\" with \"#{title}\""
  step "I select \"#{department}\" from \"Department\""
  step "I press \"Submit Ticket\""   
end

When /^I have a ticket with the title "([^"]*)"$/ do |title|
  step "an \"IT\" service provider exists"
  visit new_ticket_path  
  step "I fill in \"Title\" with \"#{title}\""
  step "I select \"IT\" from \"Department\""
  step "I press \"Submit Ticket\""   
end

Given /^a "([^"]*)" named "([^"]*)" with an email "([^"]*)" is watching a ticket with the title "([^"]*)"$/ do |priv, name, email, title|
  User.create!(:name => name, :privilege => priv, :password => "123", :email=>email)
  t = Ticket.find_by_title title
  visit ticket_path t
  step "I fill in \"Email\" with \"#{email}\""
  step "I press \"Add Watcher\""  
end

#When /^a ticket with the title "([^"]*)" exists$/ do |title|
#  step "an \"IT\" service provider exists"
#  visit new_ticket_path  
#  step "I fill in \"Title\" with \"#{title}\""
#  step "I select \"IT\" from \"Department\""
#  step "I press \"Submit Ticket\""   
#end

#When /^a closed ticket with the title "([^"]*)" exists$/ do |title|
#  step "a ticket with the title \"#{title}\" exists"
#  step "I am viewing the \"#{title}\" ticket"
#  step "I press \"Close This Ticket\""
#end

When /^I have a closed ticket with the title "([^"]*)"$/ do |title|
  step "I have a ticket with the title \"#{title}\""
  step "I am viewing the \"#{title}\" ticket"
  step "I press \"Close This Ticket\""
end

When /^I am not logged in$/ do
  assert current_user.nil?
end

When /^a.* "(.*)" service provider exists$/ do |sp|
  User.create!(:name => sp, :privilege => "service provider",:password => "123",
               :email=>"1234", :department => sp)  
end

When /^I am viewing the "(.*)" ticket$/ do |title|
  t = Ticket.find_by_title title
  visit ticket_path(t)
end

Given /^I am viewing the user page for "([^"]*)"$/ do |name|
  u = User.find_by_name name
  visit user_path(u)
end

Then /^(?:|I )should be viewing the "(.+)" ticket$/ do |title|
  t = Ticket.find_by_title title
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == ticket_path(t)
  else
    assert_equal ticket_path(t), current_path
  end
end

