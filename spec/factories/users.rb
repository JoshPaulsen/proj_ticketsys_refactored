# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:first_name) {|n| "name_#{n}"}
    sequence(:last_name) {|n| "name_#{n}"}
    sequence(:email) {|n| "name_#{n}@test.com"}    
    privilege "user"
    verified true
    active true
    encrypted_password "xxx"
    salt "xxx"
  end  
end


