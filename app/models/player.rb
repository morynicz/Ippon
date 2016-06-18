class Player < ActiveRecord::Base
  belongs_to :club
  validates :name, :surname, :birthday, :rank, :sex, :club_id, presence: true

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
    female: 0,
    male: 1
  }
end
