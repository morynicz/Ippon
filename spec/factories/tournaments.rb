def build_playoff_next_level(matches_list)
  res =  matches_list.each_slice(2).map { |e|
    create(:playoff_fight, tournament: e[0].tournament, previous_aka_fight: e[0],
      previous_shiro_fight: e[1], team_fight: nil, location: e[0].tournament.locations.shuffle.first)
    }
  build_playoff_next_level(res) unless res.size < 2
end

FactoryGirl.define do
  factory :tournament do
    state :setup
    name {"#{Faker::Address.city} Shiai"}
    playoff_match_length 3
    group_match_length 3
    team_size 3
    player_age_constraint 0
    player_age_constraint_value 0
    player_sex_constraint 0
    player_sex_constraint_value 0
    player_rank_constraint 0
    player_rank_constraint_value 0

    trait :with_participants do
      transient do
        members_count 15
      end

      after(:create) do |tournament, evaluator|
        members = create_list(:player, evaluator.members_count)
        for member in members do
          TournamentParticipation.create(player_id: member.id, tournament_id: tournament.id)
        end
      end
    end

    trait :with_admins do
      transient do
        admins_count 5
      end

      after(:create) do |tournament, evaluator|
        admins = create_list(:user, evaluator.admins_count)

        for admin in admins do
          TournamentAdmin.create(tournament_id: tournament.id, user_id: admin.id)
        end
      end
    end

    factory :tournament_with_participants_and_admins, traits: [:with_participants, :with_admins]
  end
end
