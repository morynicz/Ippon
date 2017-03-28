class PlayoffFight < ActiveRecord::Base
  validates :tournament_id, presence: true
  belongs_to :tournament
  belongs_to :team_fight, dependent: :destroy
  belongs_to :previous_shiro_fight, class_name: "PlayoffFight", foreign_key: "previous_shiro_fight_id"
  belongs_to :previous_aka_fight, class_name: "PlayoffFight", foreign_key: "previous_aka_fight_id"

  def next_fight
    PlayoffFight.where(["previous_aka_fight_id = :id or previous_shiro_fight_id = :id", {id: id}])
  end
end
