class TeamFight < ActiveRecord::Base
  validate :team_tournaments_match?
  validates :state, :location_id, presence: true
  belongs_to :shiro_team, class_name: "Team", foreign_key: "shiro_team_id", dependent: :destroy
  belongs_to :aka_team, class_name: "Team", foreign_key: "aka_team_id", dependent: :destroy

  has_many :shiro_members, through: :shiro_team, source: :players
  has_many :aka_members, through: :aka_team, source: :players
  belongs_to :location
  has_many :fights, dependent: :destroy
  has_one :group_fight, dependent: :delete #circular dependency
  has_one :group, through: :group_fight
  has_one :tournament, through: :shiro_team
  has_one :playoff_fight, dependent: :delete

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

  def team_tournaments_match?
    if shiro_team != nil && aka_team != nil &&
        shiro_team.tournament.id != aka_team.tournament.id
      errors.add(:aka_team_id, "cannot belong to other tournament than shiro team")
    end
  end
end
