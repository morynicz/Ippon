json.fight @fight, partial: 'fight', as: :fight
json.points do
  json.array! @points, partial: 'point', as: :point
end
json.aka @fight.aka, partial: 'players/player', as: :player
json.shiro @fight.shiro, partial: 'players/player', as: :player
json.is_admin @isAdmin
