

Given /^a form with the title "([^"]*)" for "([^"]*)" exists$/ do |title, sa|
  service_area = ServiceArea.find_by_name sa
  if service_area.blank?
    assert false
  end
  ServiceAreaForm.create! :title=>title, :service_area_id => service_area.id 
end

Given /^the "([^"]*)" form has a text field with the question "([^"]*)"$/ do |form_title, question|
  form = ServiceAreaForm.find_by_title form_title
  if form.blank?
    assert false
  end
  Field.create :question => question, :field_type => "text", :position => form.fields.count+1, :form_id => form.id
end


Given /^I am viewing the "([^"]*)" form$/ do |title|
  sa = ServiceAreaForm.find_by_title title
  assert sa, "Service Area Form Not Found"
  visit service_area_form_path(sa)
end

Then /^(?:|I )should be viewing the "([^"]*)" form/ do |title|
  sa = ServiceAreaForm.find_by_title title
  assert sa, "Service Area Form Not Found"
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == service_area_form_path(sa)
  else
    assert_equal service_area_form_path(sa), current_path
  end
end

Then /^I should be viewing the new field page for the "([^"]*)" form$/ do |title|
  sa = ServiceAreaForm.find_by_title title
  assert sa, "Service Area Form Not Found"
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == new_form_field_path(sa)
  else
    assert_equal new_form_field_path(sa), current_path
  end
end

Given /^I am viewing the new field page for the "([^"]*)" form$/ do |title|
  sa = ServiceAreaForm.find_by_title title
  assert sa, "Service Area Form Not Found"
  visit new_form_field_path(sa)
end


