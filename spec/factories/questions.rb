# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    ticket_id 1
    question "MyString"
    answer "MyText"
  end
end
