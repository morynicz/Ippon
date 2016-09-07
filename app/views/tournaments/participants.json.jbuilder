json.participants do
  json.array! @participants, partial: 'players/player', as: :player
end
json.players do
  json.array! @players, partial: 'players/player', as: :player
end
