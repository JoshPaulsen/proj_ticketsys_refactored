
Given /^an active location named "([^"]*)" exists$/ do |name|

  l = Location.find_by_name name
  if l
    assert l.active == true
  else
    Location.create!:name=>name, :active=> true 
  end
  
end

Given /^an active location named "([^"]*)" with the address "([^"]*)" exists$/ do |name, address|
  l = Location.find_by_name name
  if l
    assert l.active == true
    assert l.address == address
  else
    Location.create!:name=>name, :active=> true, :address => address
  end
end


Given /^an inactive location named "([^"]*)" exists$/ do |name|
  l = Location.find_by_name name
  if l
    assert l.active == false
  else
    Location.create!:name=>name, :active=> false 
  end
end

Given /^an inactive location named "([^"]*)" with the address "([^"]*)" exists$/ do |name, address|
  l = Location.find_by_name name
  if l
    assert l.active == false
    assert l.address == address
  else
    Location.create!:name=>name, :active=> false, :address => address
  end
end

Given /^I am viewing the location page for "([^"]*)"$/ do |name|
  l = Location.find_by_name name
  visit location_path(l)
end

Then /^(?:|I )should be viewing the "([^"]*)" location/ do |name|
  l = Location.find_by_name name
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == location_path(l)
  else
    assert_equal location_path(l), current_path
  end
end