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

    factory :club_with_admins do
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
  end
end
