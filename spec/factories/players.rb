FactoryGirl.define do
  factory :player do
    sequence(:name) {|n| "Name#{n}"}
    sequence(:surname) {|n| "Surname#{n}"}
    birthday {Faker::Date.between(60.years.ago, 5.years.ago)}
    rank {Player.ranks.invert[Faker::Number.between(0,13)]}
    sex {Player.sexes.invert[Faker::Number.between(0,1)]}
    club_id {FactoryGirl::create(:club).id}
  end
end
