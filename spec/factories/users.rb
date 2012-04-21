# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "name_#{n}"}
    sequence(:email) {|n| "name_#{n}@test.com"}    
    privilege "user"
    password "password"
    active true
  end
end


