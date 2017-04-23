def build_playoff_next_level(matches_list)
  res =  matches_list.each_slice(2).map { |e|
    FactoryGirl::create(:playoff_fight, tournament: e[0].tournament, previous_aka_fight: e[0],
      previous_shiro_fight: e[1], team_fight: nil)
    }
  build_playoff_next_level(res) unless res.size < 2
end

FactoryGirl.define do
  factory :tournament do
    state :setup
    city {Faker::Address.city}
    name {"#{city} Shiai"}
    sequence(:address) {|n| "Somestreet #{n}"}
    date {Faker::Date.between(5.years.ago, 5.years.from_now)}
    playoff_match_length 3
    group_match_length 3
    team_size 3
    player_age_constraint 0
    player_age_constraint_value 0
    player_sex_constraint 0
    player_sex_constraint_value 0
    player_rank_constraint 0
    player_rank_constraint_value 0

    trait :with_participants do
      transient do
        members_count 15
      end

      after(:create) do |tournament, evaluator|
        members = create_list(:player, evaluator.members_count)
        for member in members do
          TournamentParticipation.create(player_id: member.id, tournament_id: tournament.id)
        end
      end
    end

    trait :with_admins do
      transient do
        admins_count 5
      end

      after(:create) do |tournament, evaluator|
        admins = create_list(:user, evaluator.admins_count)

        for admin in admins do
          TournamentAdmin.create(tournament_id: tournament.id, user_id: admin.id)
        end
      end
    end

    trait :with_teams do
      transient do
        teams_count 15
      end

      after(:create) do |tournament, evaluator|
        create_list(:team_with_players, evaluator.teams_count, tournament: tournament)
      end
    end

    trait :with_groups do
      transient do
        group_count 4
      end

      after(:create) do |tournament, evaluator|
        members = tournament.teams
        for part in members.in_groups(evaluator.group_count, false) do
          create(:group_with_members_list_and_fights, tournament: tournament, members: part)
        end
      end
    end

    trait :with_playoffs do
      transient do
        number_of_players 5
      end

      after(:create) do |tournament, evaluator|
        base_size = 2**(Math::log(evaluator.number_of_players, 2).ceil)
        playoff_teams = []
        if tournament.teams.size < evaluator.number_of_players
          create_list(:team, evaluator.number_of_players, tournament: tournament)
        end
        teams = tournament.teams.shuffle

        evaluator.number_of_players.times {
          playoff_teams << teams.shift
        }

        playoffs = create_list(:playoff_fight, base_size / 2, tournament: tournament)

        for playoff in playoffs do
          team = playoff_teams.shift
          team_fight = create(:team_fight, aka_team_id: team.id, shiro_team_id: nil, tournament: tournament)
          playoff.team_fight = team_fight
          playoff.save
        end

        for playoff in playoffs do
          break if playoff_teams.empty?
          team = playoff_teams.shift
          playoff.team_fight.shiro_team_id = team.id
          playoff.team_fight.save
        end
        build_playoff_next_level(playoffs)
      end
    end

    factory :tournament_with_participants_and_admins, traits: [:with_participants, :with_admins]
    factory :tournament_with_playoffs, traits: [:with_playoffs]
    factory :tournament_with_all, traits: [:with_teams, :with_admins, :with_groups, :with_playoffs, :with_participants]
  end
end
