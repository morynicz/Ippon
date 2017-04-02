json.array! @teams do |team|
  json.team team, partial: 'team', as: :team
  json.players do
    json.array! team.players, partial: 'players/player', as: :player
  end
end
