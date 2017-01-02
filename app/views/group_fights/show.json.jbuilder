json.group_fight @group_fight, partial: 'group_fight', as: :group_fight
json.team_fight @group_fight.team_fight, partial: 'team_fights/team_fight', as: :team_fight
json.is_admin @isAdmin
