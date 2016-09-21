json.team_fight @team_fight, partial: 'team_fight', as: :team_fight
json.fights do
  json.array! @fights, partial: 'fights/fight', as: :fight
end
json.aka_team @team_fight.aka_team, partial: 'teams/team', as: :team
json.shiro_team @team_fight.shiro_team, partial: 'teams/team', as: :team
json.is_admin @isAdmin
