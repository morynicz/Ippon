FactoryGirl.define do
  factory :tournament do
    state 1
    name "MyString"
    playoff_match_length 1
    group_match_length 1
    team_size 1
    player_age_constraint 1
    player_age_constraint_value 1
    player_sex_constraint 1
    player_sex_constraint_value 1
    player_rank_constraint 1
    player_rank_constraint_value 1
  end
end
