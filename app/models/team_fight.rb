class TeamFight < ActiveRecord::Base
  belongs_to :shiro_team, class_name: "Team", foreign_key: "shiro_team_id"
  belongs_to :aka_team, class_name: "Team", foreign_key: "aka_team_id"

  has_many :shiro_members, through: :shiro_team, source: :players
  has_many :aka_members, through: :aka_team, source: :players
  has_one :tournament, through: :shiro_team, source: :tournament
  belongs_to :location
  has_many :fights

  def aka_score
    fights.to_a.sum {|f| f.aka_score}
  end

  def shiro_score
    fights.to_a.sum {|f| f.shiro_score}
  end
end
