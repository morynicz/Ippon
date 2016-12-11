json.array! @groups do |group|
  json.group group, partial: 'group', as: :group
  json.teams do
    json.array! group.teams, partial: 'teams/team', as: :team
  end
  json.team_fights do
    json.array! group.team_fights, partial: 'team_fights/team_fight', as: :team_fight
  end
end
