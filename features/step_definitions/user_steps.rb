

Given /^a[n]? "([^"]*)" named "([^"]*)" exists$/ do |privilege,name|
  u = User.find_by_first_name name
  if u
    assert u.privilege == privilege
    assert u.name == name
  else
    u = User.new :first_name=>name,:privilege=>privilege.downcase,:email=>name
    u.last_name = name
    u.verified = true
    u.active = true
    u.set_encrypted_password name
    u.save!
  end
  
end

Given /^a[n]? "([^"]*)" service provider named "([^"]*)" exists$/ do |sa,name|
  
  ser_area = ServiceArea.find_by_name sa
  if !ser_area
    ser_area = ServiceArea.create! :name => sa
  end
  
  u = User.find_by_first_name name
  if u
    assert u.first_name == name, "Name does not equal"
    assert u.privilege == "service provider", "Not a service provider"
    assert u.service_areas.include?(ser_area), "Is not a service provider in #{sa}"
  else
    u = User.new :first_name=>name, :privilege=>"service provider",:email=>name
    u.verified = true    
    u.active = true
    u.set_encrypted_password name
    u.last_name = name    
    u.add_service_area_by_id ser_area.id
    u.save!
  end
  assert u.service_areas.include?(ser_area), "Service Area was not assigned"
end



Given /^a[n]? "([^"]*)" named "([^"]*)" with the password "([^"]*)" exists$/ do |privilege,name, pw|
  u = User.find_by_first_name name
  
  if u
    assert u.first_name == name, "Name does not equal"
    assert u.privilege == privilege, "Privilege does not equal"    
  else
    u = User.new(:first_name=>name, :last_name => name, :privilege=>privilege.downcase,:email=>name)
    u.active = true
    u.verified = true
    u.set_encrypted_password pw
    u.save!  
  end
end

Given /^a deactivated "([^"]*)" named "([^"]*)" with the password "([^"]*)" exists$/ do |privilege,name, pw|
  u = User.find_by_first_name name
  
  if u
    assert u.first_name == name, "Name does not equal"
    assert u.privilege == privilege, "Privilege does not equal"    
    assert u.active == false, "User is active"
  else
    u = User.new(:first_name=>name, :last_name => name, :privilege=>privilege.downcase,:email=>name)
    u.active = false
    u.verified = true
    u.set_encrypted_password pw
    u.save!   
  end
end

When /^a[n]? "([^"]*)" with the password "(.*)" exists$/ do |privilege, password|
  u = User.create!:name=>"abc",:password=>password,:privilege=>privilege,:email=>"abc"
  u.active = true
  u.save!  
end

When /^a[n]? "([^"]*)" with the email "(.*)" exists$/ do |privilege, email|
  u = User.create!:name=>email,:password=>email,:privilege=>privilege.downcase,:email=>email
  u.active = true
  u.save!  
end

When /^a[n]? "([^"]*)" named "([^"]*)" with the email "(.*)" exists$/ do |privilege,name, email|
  u = User.new :first_name=>name,:privilege=>privilege.downcase,:email=>email
  u.last_name = name
  u.verified = true
  u.active = true
  u.set_encrypted_password name
  u.save!  
end

When /^the user "(.*)" does not exist$/ do |name|
  user = User.find_by_name(name)
  assert user.nil?
end

Given /^I am viewing the user page for "([^"]*)"$/ do |name|
  u = User.find_by_first_name name
  assert u, "User does not exist"
  visit user_path(u)
end


