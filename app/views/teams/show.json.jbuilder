json.team @team, partial: 'team', as: :team
json.players do
  json.array! @players, partial: 'players/player', as: :player  
end
