FactoryGirl.define do
  factory :playoff_fight do
    tournament
    team_fight {build(:team_fight, tournament: tournament)}
    previous_aka_fight nil
    previous_shiro_fight nil
    location {tournament.locations.shuffle.first}
  end
end
