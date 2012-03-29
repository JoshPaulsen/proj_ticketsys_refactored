# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "name"
    email "me@me.com"
    privilege "user"
    password "password"
    location "office"
    department "IT"
  end
end
