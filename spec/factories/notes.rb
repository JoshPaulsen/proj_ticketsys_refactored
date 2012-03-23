# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    body "MyText"
    user_id 1
    ticket_id 1
    hidden false
  end
end
