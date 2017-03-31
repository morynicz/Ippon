json.array! @playoff_fights do |playoff_fight|
  json.playoff_fight playoff_fight, partial: 'playoff_fight', as: :playoff_fight
  json.team_fight playoff_fight.team_fight, partial: 'team_fights/team_fight', as: :team_fight
end
