class Tournament < ActiveRecord::Base
  validates :name, :team_size, :playoff_match_length,
    :group_match_length, :player_age_constraint, :player_age_constraint_value,
    :player_rank_constraint, :player_rank_constraint_value,
    :player_sex_constraint, :player_sex_constraint_value, :date, :city, :address, presence: true

  after_commit :add_admin, on: :create

  has_many :tournament_participations, dependent: :destroy
  has_many :players, through: :tournament_participations
  has_many :teams, dependent: :destroy
  has_many :team_memberships, through: :teams
  has_many :team_members, through: :team_memberships, source: :player
  has_many :locations, dependent: :destroy
  has_many :tournament_admins, dependent: :destroy
  has_many :admins, through: :tournament_admins, source: :user
  has_many :groups, dependent: :destroy
  has_many :group_fights, through: :groups
  has_many :playoff_fights, dependent: :destroy

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

  enum player_age_constraint: {
    age_no_constraint: 0,
    age_less_or_equal: 1,
    age_greater_or_equal: 2,
    age_equal: 3
  }

  enum player_rank_constraint: {
  rank_no_constraint: 0,
  rank_less_or_equal: 1,
  rank_greater_or_equal: 2,
  rank_equal: 3
}

enum player_sex_constraint: {
  sex_no_constraint: 0,
  sex_equal: 1
}

  enum player_rank_constraint_value: {
    kyu_6: 0,
    kyu_5: 1,
    kyu_4: 2,
    kyu_3: 3,
    kyu_2: 4,
    kyu_1: 5,
    dan_1: 6,
    dan_2: 7,
    dan_3: 8,
    dan_4: 9,
    dan_5: 10,
    dan_6: 11,
    dan_7: 12,
    dan_8: 13
  }

  enum player_sex_constraint_value: {
    woman_only: 0,
    man_only: 1,
    all_allowed: 2
  }

  def add_admin
    if @creator != nil
      TournamentAdmin.create(tournament_id: self.id, user_id: @creator.id, status: :main) unless TournamentAdmin.exists?(tournament_id: self.id, user_id: @creator.id)
    end
  end
end
