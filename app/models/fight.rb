class Fight < ActiveRecord::Base
  belongs_to :team_fight
  belongs_to :aka, class_name: "Player", foreign_key: "aka_id"
  belongs_to :shiro, class_name: "Player", foreign_key: "shiro_id"

  has_one :tournament, through: :team_fight
  has_many :points

  enum state: {
    not_started: 0,
    started: 1,
    finished: 2
  }
end
