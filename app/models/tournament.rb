class Tournament < ActiveRecord::Base
  validates :name, :team_size, :playoff_match_length,
    :group_match_length, :player_age_constraint, :player_age_constraint_value,
    :player_rank_constraint, :player_rank_constraint_value,
    :player_sex_constraint, :player_sex_constraint_value, :date, :city, :address, presence: true

  after_commit :add_admin, on: :create

  has_many :tournament_participations
  has_many :players, through: :tournament_participations
  has_many :teams
  has_many :team_memberships, through: :teams
  has_many :team_members, through: :team_memberships, source: :player
  has_many :locations
  has_many :tournament_admins
  has_many :admins, through: :tournament_admins, source: :user
  has_many :groups, dependent: :destroy
  has_many :group_fights, through: :groups
  has_many :playoff_fights

  attr_accessor :creator

  enum state: {
    setup: 0,
    registration: 1,
    verification: 2,
    preparation: 3,
    groups: 4,
    playoff: 5,
    closed: 6
  }

  enum constraint: {
    no_constraint: 0,
    less_or_equal: 1,
    greater_or_equal: 2,
    equal: 3
  }

  def add_admin
    if @creator != nil
      TournamentAdmin.create(tournament_id: self.id, user_id: @creator.id, status: :main) unless TournamentAdmin.exists?(tournament_id: self.id, user_id: @creator.id)
    end
  end
end
