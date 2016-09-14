class Team < ActiveRecord::Base
  validates :name, :tournament_id, presence: true
  belongs_to :tournament
  has_many :team_memberships
  has_many :players, through: :team_memberships
  has_many :team_fights
end
