FactoryGirl.define do
  factory :team_fight do
    shiro_team {create(:team)}
    aka_team {create(:team, tournament: shiro_team.tournament)}
  end
end
