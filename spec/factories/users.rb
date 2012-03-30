# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "name_#{n}"}
    sequence(:email) {|n| "name_#{n}@test.com"}    
    privilege "user"
    password "password"
    location "office"
    department "IT"
  end
end


