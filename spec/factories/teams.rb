FactoryGirl.define do
  factory :team do
    name {Faker::Lorem.word}
    tournament_id {FactoryGirl::create(:tournament).id}
    required_size {Tournament.find(tournament_id).team_size}

    factory :team_with_players do
      transient do
        players_count {required_size}
      end

      after(:create) do |team, evaluator|
        players = create_list(:player, evaluator.players_count)
        for player in players do
          TeamMembership.create(player_id: player.id, team_id: team.id)
          TournamentParticipation.create(player_id: player.id, tournament_id: team.tournament_id)
        end
      end
    end
  end
end
