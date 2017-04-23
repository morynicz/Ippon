FactoryGirl.define do
  factory :club do
    sequence(:name) { |n| "Club #{n}"}
    city {Faker::Address.city}
    description {Faker::Lorem.paragraph}
    trait :with_players do
      transient do
        players_count 5
      end

      after(:create) do |club, evaluator|
        create_list(:player,evaluator.players_count, club_id: club.id)
      end
    end

    trait :with_admins do
      transient do
        admins_count 3
      end

      after(:create) do |club, evaluator|
        admins = create_list(:user, evaluator.admins_count)
        for admin in admins do
          ClubAdmin.create(club_id: club.id, user_id: admin.id)
        end
      end
    end

    factory :club_with_players, traits: [:with_players]
    factory :club_with_admins, traits: [:with_admins]
    factory :club_with_players_and_admins, traits: [:with_players, :with_admins]
  end
end
