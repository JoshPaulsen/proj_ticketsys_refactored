
# This won't work anymore.  Other related models are affected when a ticket is created.
# If we need to load a bunch of tickets we are going to have to write a more complicated step. 
#When /the following tickets exist/ do |tickets_table|
  #tickets_table.hashes.each do |ticket|
    #Ticket.create!(ticket)
  #end
#end
# Will we evere care about a name?

#
When /^I have a[n]? "([^"]*)" ticket with the title "([^"]*)"$/ do |s_area,title|
  step "an active location named \"Main Office\" exists"
  step "an active service area named \"#{s_area}\" exists"
  step "a form with the title \"Fix Me\" for \"#{s_area}\" exists"
  visit new_ticket_path  
  step "I select \"Main Office\" from \"Location\""
  step "I select \"#{s_area}\" from \"Service Area\""
  step "I select \"Fix Me\" from \"Ticket Type\""
  step "I press \"Next\""
  step "I fill in \"Title\" with \"#{title}\""  
  step "I press \"Create Ticket\""   
end

When /^I have a[n]? "([^"]*)" ticket with the title "([^"]*)" using the "([^"]*)" form$/ do |s_area,title, form_title|
  step "an active location named \"Main Office\" exists"
  step "an active service area named \"#{s_area}\" exists"  
  visit new_ticket_path  
  step "I select \"Main Office\" from \"Location\""
  step "I select \"#{s_area}\" from \"Service Area\""
  step "I select \"#{form_title}\" from \"Ticket Type\""
  step "I press \"Next\""
  step "I fill in \"Title\" with \"#{title}\""  
  step "I press \"Create Ticket\""   
end



When /^I have a ticket with the title "([^"]*)"$/ do |title|
  step "I have an \"IT\" ticket with the title \"#{title}\""  
end

Given /^a "([^"]*)" named "([^"]*)" with an email "([^"]*)" is watching a ticket with the title "([^"]*)"$/ do |priv, name, email, title|
  User.create!(:name => name, :privilege => priv, :password => "123", :email=>email)
  t = Ticket.find_by_title title
  visit ticket_path t
  step "I fill in \"Email\" with \"#{email}\""
  step "I press \"Add Watcher\""  
end



Given /^a ticket with the title "([^"]*)" exists and is assigned to a[n]? "([^"]*)" service provider named "([^"]*)"$/ do |title, s_area, name|
  step "\"Someone\" is signed in as a \"user\""
  step "I have a \"#{s_area}\" ticket with the title \"#{title}\""
  t = Ticket.find_by_title title
  sp = t.provider
  sp.name= name
  sp.save
  step "\"Someone\" signs out"
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
  step "I press \"Close Ticket\""
end


When /^I am viewing the "(.*)" ticket$/ do |title|
  t = Ticket.find_by_title title
  assert t, "Ticket Not Found"
  visit ticket_path(t)
end



Then /^(?:|I )should be viewing the "(.+)" ticket$/ do |title|
  t = Ticket.find_by_title title
  assert t, "Ticket Not Found"
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == ticket_path(t)
  else
    assert_equal ticket_path(t), current_path
  end
end

Then /^(?:|I )should be viewing the edit page for the "(.+)" ticket$/ do |title|
  t = Ticket.find_by_title title
  assert t, "Ticket Not Found"
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == edit_ticket_path(t)
  else
    assert_equal edit_ticket_path(t), current_path
  end
end

