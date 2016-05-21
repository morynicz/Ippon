FactoryGirl.define do
  factory :club do
    name {Faker::Lorem.word}
    city {Faker::Address.city}
    description {Faker::Lorem.paragraph}
  end
end
