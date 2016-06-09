FactoryGirl.define do
  sequence :uname do |n|
    "#{Faker::Internet.user_name}#{n}"
  end

  factory :user do
    email { Faker::Internet.email }
    username {generate(:uname)}
    password "password"
    password_confirmation "password"
  end
end
