FactoryGirl.define do
  factory :playoff_fight, aliases: [:previous_aka_fight, :previous_shiro_fight] do
    tournament
    team_fight nil
    previous_aka_fight nil
    previous_shiro_fight nil

    trait :with_previous_fights do
      previous_aka_fight {association :previous_aka_fight, tournament: tournament}
      previous_shiro_fight {association :previous_shiro_fight, tournament: tournament}
    end

    trait :with_team_fight do
      team_fight {association :team_fight, tournament: tournament}
    end
    factory :playoff_fight_with_previous_fights, traits: [:with_previous_fights]
    factory :playoff_fight_with_team_fight, traits: [:with_team_fight]
  end
end
