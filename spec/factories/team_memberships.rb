FactoryGirl.define do
  factory :team_membership do
    player
    team

    after(:create) do |team|
      if !TournamentParticipation.exists?(tournament_id: team.tournament.id,
          player_id: team.player.id)
        TournamentParticipation.create(tournament_id: team.tournament.id,
          player_id: team.player.id)
        end
    end
  end
end
