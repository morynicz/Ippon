json.group @group, partial: 'group', as: :group
json.teams do
  json.array! @teams, partial: 'teams/team', as: :team
end
json.team_fights do
  json.array! @team_fights, partial: 'team_fights/team_fight', as: :team_fight
end
json.is_admin @isAdmin
