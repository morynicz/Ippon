FactoryGirl.define do
  factory :fight do
    team_fight
    association :aka, factory: :player
    association :shiro, factory: :player

    after(:create) do |fight|
      TeamMembership.create(team: fight.team_fight.aka_team, player: fight.aka)
      TeamMembership.create(team: fight.team_fight.shiro_team, player: fight.shiro)
    end
  end
end
