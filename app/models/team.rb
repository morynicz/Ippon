class Team < ActiveRecord::Base
  validates :name, :tournament_id, presence: true
  belongs_to :tournament
  has_many :team_memberships, dependent: :destroy
  has_many :players, through: :team_memberships
  has_many :team_fights_aka_side, class_name: :"TeamFight", foreign_key: "aka_team_id"
  has_many :team_fights_shiro_side, class_name: "TeamFight", foreign_key: "shiro_team_id"
  has_one :group_member, dependent: :destroy

  def team_fights
    team_fights_aka_side + team_fights_shiro_side
  end
end
