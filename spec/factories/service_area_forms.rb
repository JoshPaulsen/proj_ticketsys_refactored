# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :service_area_form do
    default_provider_id 1
    service_area_id 1
    title "MyString"
  end
end
