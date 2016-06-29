FactoryGirl.define do
  factory :club do
    name {Faker::Lorem.word}
    city {Faker::Address.city}
    description {Faker::Lorem.paragraph}

    factory :club_with_players do
      transient do
        players_count 5
      end

      after(:create) do |club, evaluator|
        create_list(:player,evaluator.players_count, club_id: club.id)
      end
    end
  end
end
