FactoryGirl.define do
  factory :team_fight do
    transient do
      tournament {FactoryGirl::create(:tournament)}
    end
    shiro_team {create(:team, tournament: tournament)}
    aka_team {create(:team, tournament: tournament)}
    location {create(:location, tournament: tournament)}
    state :started

    after(:create) do |team_fight, evaluator|
      g = FactoryGirl::create(:group, tournament: team_fight.shiro_team.
        tournament)
      GroupFight.create(group: g, team_fight: team_fight)
      GroupMember.create(group: g, team: team_fight.aka_team)
      GroupMember.create(group: g, team: team_fight.shiro_team)
    end

    factory :team_fight_with_fights_and_points do
      transient do
        shiro_points 2
        aka_points 1
      end

      after(:create) do |team_fight, evaluator|
        FactoryGirl::create_list(:fight, team_fight.tournament.team_size,
          team_fight: team_fight)
        evaluator.shiro_points.times {
          fight = team_fight.fights.shuffle.first
          FactoryGirl::create(:point, fight: fight, player: fight.aka)
        }

        evaluator.aka_points.times {
          fight = team_fight.fights.shuffle.first
          FactoryGirl::create(:point, fight: fight, player: fight.shiro)
        }
      end
    end
  end
end
