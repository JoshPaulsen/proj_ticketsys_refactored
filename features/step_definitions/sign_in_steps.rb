

When /^"([^"]*)" is (logged|signed) (o|i)n as a[n]? "(.*)"/ do |name, x, y, privilege|
  user = User.new(:first_name => name, :last_name => name, :privilege => privilege, :email => name)
  user.active = true
  user.verified = true
  user.set_encrypted_password privilege
  user.save!
  visit signin_path
  step "I fill in \"Email\" with \"#{name}\""
  step "I fill in \"Password\" with \"#{privilege}\""
  step "I press \"Sign In\""
end



When /^I am (logged|signed) (o|i)n as a[n]? "(.*)"$/ do |x,y,privilege|
  u = User.new(:first_name => privilege + "x", :last_name => privilege, :privilege => privilege, :email=>privilege + "x")
  u.active = true
  u.verified = true
  u.set_encrypted_password "xxx"
  u.save!
  visit signin_path
  step "I fill in \"Email\" with \"#{u.email}\""
  step "I fill in \"Password\" with \"xxx\""
  step "I press \"Sign In\""
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
