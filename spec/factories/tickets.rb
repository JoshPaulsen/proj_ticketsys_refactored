# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ticket do
    title "MyString"
    description "MyText"
    location "MyString"
    opened_on "2012-03-23 16:10:58"
    closed_on "2012-03-23 16:10:58"
    creator_id 1
    provider_id 1
  end
end
