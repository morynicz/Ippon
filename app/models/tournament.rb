class Tournament < ActiveRecord::Base
  after_commit :add_admin, on: :create
  has_many :tournament_participations
  has_many :players, through: :tournament_participations
  validates :name, :team_size, :playoff_match_length,
    :group_match_length, :player_age_constraint, :player_age_constraint_value,
    :player_rank_constraint, :player_rank_constraint_value,
    :player_sex_constraint, :player_sex_constraint_value, presence: true

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
