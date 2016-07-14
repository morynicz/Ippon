FactoryGirl.define do
  factory :team do
    name {Faker::Lorem.word}
    required_size 1
    tournament {FactoryGirl::create(:tournament)}

    factory :team_with_players do
      transient do
        players_count 5
      end

      after(:create) do |team, evaluator|
        players = create_list(:player, evaluator.players_count)
        for player in players do
          TeamMembership.create(player_id: player.id, team_id: team.id)
        end
      end
    end
  end
end
