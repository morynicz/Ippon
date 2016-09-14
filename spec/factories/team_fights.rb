FactoryGirl.define do
  factory :team_fight do
    association :shiro_team, factory: :team
    association :aka_team, factory: :team
  end
end
