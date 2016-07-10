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
  end
end
