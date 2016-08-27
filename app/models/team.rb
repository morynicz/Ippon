class Team < ActiveRecord::Base
  validates :name, :required_size, :tournament_id, presence: true
  belongs_to :tournament
  has_many :team_memberships
  has_many :players, through: :team_memberships
end
