FactoryGirl.define do
  factory :group do
    tournament
    sequence(:name, 'A') {|n| "Group #{n}"}

    factory :group_with_members do
      transient do
        members_count 4
      end

      after(:create) do |group, evaluator|
        members = create_list(:team, evaluator.members_count, tournament: group.tournament)

        for member in members do
          GroupMember.create(team_id: member.id, group_id: group.id)
        end
      end

      factory :group_with_fights do
        after(:create) do |group, evaluator|
          members = group.group_members

          members.combination(2) {|c|
            tf = FactoryGirl::create(:team_fight, tournament: group.tournament, aka_team: c[0].team, shiro_team: c[1].team)
            GroupFight.create(group_id: group.id, team_fight_id: tf.id)
          }
        end
      end
    end
  end
end
