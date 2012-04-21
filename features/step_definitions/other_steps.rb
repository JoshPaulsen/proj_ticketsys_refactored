When /^I confirm popup$/ do
  page.driver.browser.switch_to.alert.accept    
end

When /^I dismiss popup$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Then /^I should see a button that says "([^"]*)"$/ do |text|
  assert has_button?(text)
end
