json.array! @group_fights do |group_fight|
  json.group_fight group_fight, partial: 'group_fight', as: :group_fight
  json.team_fight group_fight.team_fight, partial: 'team_fights/team_fight', as: :team_fight
end
