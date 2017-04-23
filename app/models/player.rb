class Player < ActiveRecord::Base
  belongs_to :club
  validates :name, :surname, :birthday, :rank, :sex, :club_id, presence: true

  has_many :points, dependent: :destroy
  has_many :fights_aka_side, dependent: :nullify, class_name: "Fight", foreign_key: "aka_id"
  has_many :fights_shiro_side, dependent: :nullify, class_name: "Fight", foreign_key: "shiro_id"
  has_many :tournament_participations, dependent: :destroy
  has_many :team_memberships, dependent: :destroy

  enum rank: {
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

  enum sex: {
    woman: 0,
    man: 1
  }

  def gained_points
    fights.points - points
  end

  def fights
    fights_shiro_side + fights_aka_side
  end
end
