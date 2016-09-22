class TeamFight < ActiveRecord::Base
  validates :state, :aka_team_id, :shiro_team_id, :location_id, presence: true
  belongs_to :shiro_team, class_name: "Team", foreign_key: "shiro_team_id"
  belongs_to :aka_team, class_name: "Team", foreign_key: "aka_team_id"

  has_many :shiro_members, through: :shiro_team, source: :players
  has_many :aka_members, through: :aka_team, source: :players
  belongs_to :location
  has_many :fights, dependent: :destroy
  has_one :group_fight
  has_one :group, through: :group_fight

  def tournament
    group.tournament
  end

  enum state: {
    not_started: 0,
    started: 1,
    finished: 2
  }

  def aka_score
    fights.to_a.sum {|f| f.aka_score}
  end

  def shiro_score
    fights.to_a.sum {|f| f.shiro_score}
  end
end
