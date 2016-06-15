FactoryGirl.define do
  factory :player do
    name {Faker::Name.first_name}
    surname {Faker::Name.last_name}
    birthday {Faker::Date.between(60.years.ago, 5.years.ago)}
    rank {Faker::Number.between(0,13)}
    sex {Faker::Number.between(0,1)}
    club_id {FactoryGirl::create(:club).id}
  end
end
