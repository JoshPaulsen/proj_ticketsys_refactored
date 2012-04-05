# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :form_field do
    description "MyString"
    field_type "MyString"
    ticket_form_id 1
    options "MyText"
  end
end
