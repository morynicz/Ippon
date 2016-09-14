class TeamFight < ActiveRecord::Base
  belongs_to :shiro_team, class_name: "Team", foreign_key: "shiro_team_id"
  belongs_to :aka_team, class_name: "Team", foreign_key: "aka_team_id"

  has_many :shiro_members, through: :shiro_team, source: :players
  has_many :aka_members, through: :aka_team, source: :players
end
