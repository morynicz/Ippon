FactoryGirl.define do
  factory :group_fight do
    group
    team_fight {build(:team_fight, tournament: group.tournament)}

    after(:create) do |group_fight|
      group_fight.team_fight.save!
      GroupMember.create(group_id: group_fight.group.id, team_id: group_fight.
        team_fight.aka_team_id)
      GroupMember.create(group_id: group_fight.group.id, team_id: group_fight.
        team_fight.shiro_team_id)
    end
  end
end
