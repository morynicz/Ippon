FactoryGirl.define do
  factory :tournament do
    state :setup
    name {"#{Faker::Address.city} Shiai"}
    playoff_match_length 3
    group_match_length 3
    team_size 1
    player_age_constraint 0
    player_age_constraint_value 0
    player_sex_constraint 0
    player_sex_constraint_value 0
    player_rank_constraint 0
    player_rank_constraint_value 0

    factory :tournament_with_members_and_admins do
      transient do
        members_count 15
        admins_count 5
      end

      after(:create) do |tournament, evaluator|
        members = create_list(:player, evaluator.members_count)
        for member in members do
          TournamentMembership.create(player_id: member.id, tournament_id: tournament.id)
        end

        admins = create_list(:user, evaluator.admins_count)

        for admin in admins do
          TournamentAdmin.create(tournament_id: tournament.id, user_id: admin.id)
        end
      end
    end
  end
end
