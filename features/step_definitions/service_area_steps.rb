
Given /^an active service area named "([^"]*)" exists$/ do |name|
  sa = ServiceArea.find_by_name name
  if sa
    assert sa.active == true
  else
    ServiceArea.create!:name=>name, :active=> true 
  end
end

Given /^an active service area named "([^"]*)" with the description "([^"]*)" exists$/ do |name, des|
  sa = ServiceArea.find_by_name name
  if sa
    assert sa.active == true
    assert sa.description == des
  else
    ServiceArea.create!:name=>name, :active=> true, :description => des
  end
end


Given /^an inactive service area named "([^"]*)" exists$/ do |name|
  sa = ServiceArea.find_by_name name
  if sa
    assert sa.active == false
  else
    ServiceArea.create!:name=>name, :active=> false 
  end
end

Given /^an inactive service area named "([^"]*)" with the description "([^"]*)" exists$/ do |name, des|
  sa = ServiceArea.find_by_name name
  if sa
    assert sa.active == false
    assert sa.description == des
  else
    ServiceArea.create!:name=>name, :active=> false, :description => des
  end
end

Given /^I am viewing the service area page for "([^"]*)"$/ do |name|
  sa = ServiceArea.find_by_name name
  visit service_area_path(sa)
end

Then /^(?:|I )should be viewing the "([^"]*)" service area/ do |name|
  sa = ServiceArea.find_by_name name
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == service_area_path(sa)
  else
    assert_equal service_area_path(sa), current_path
  end
end
