

When /^"([^"]*)" is (logged|signed) (o|i)n as a[n]? "(.*)"/ do |name, x, y, privilege|
  user = User.create!(:name => name, :privilege => privilege, :password => privilege, :email => name)  
  visit signin_path
  step "I fill in \"Username\" with \"#{name}\""
  step "I fill in \"Password\" with \"#{privilege}\""
  step "I press \"Sign in\""
end



When /^I am (logged|signed) (o|i)n as a[n]? "(.*)"$/ do |x,y,privilege|
  u = User.create!(:name => privilege + "x", :privilege => privilege, :password => "xxxx", :email=>privilege + "x")
  visit signin_path
  step "I fill in \"Username\" with \"#{u.name}\""
  step "I fill in \"Password\" with \"#{u.password}\""
  step "I press \"Sign in\""
end

When /^I am (logged|signed) (o|i)n as a[n]? "(.*)" in the "([^"]*)" service area$/ do |x,y,privilege, s_area|
  u = User.create!(:name => privilge+"1", :privilege => privilege, :password => "1", :email=>privilege+"1", :department => s_area)
  visit signin_path
  step "I fill in \"Username\" with \"#{user.name}\""
  step "I fill in \"Password\" with \"#{user.password}\""
  step "I press \"Sign in\""
end

When /^"([^"]*)" (logs|signs) out$/ do |name,x|
  u = User.find_by_name name
  visit user_path u
  step "I follow \"#{name}\""
end

When /^I (log|sign) out$/ do |x|
  step "I follow \"signout\""  
end

When /^I am not logged in$/ do
  assert current_user.nil?
end
