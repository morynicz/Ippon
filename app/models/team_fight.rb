class TeamFight < ActiveRecord::Base
  belongs_to :shiro_team, class_name: "Team", foreign_key: "shiro_team_id"
  belongs_to :aka_team, class_name: "Team", foreign_key: "aka_team_id"
end
